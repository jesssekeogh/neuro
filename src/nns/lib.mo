import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Random "mo:base/Random";
import Nat64 "mo:base/Nat64";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Sha256 "mo:sha2/Sha256";
import Binary "mo:encoding/Binary";
import AccountIdentifier "mo:account-identifier";
import IcpLedgerInterface "../interfaces/ledger_interface";
import IcpGovernanceInterface "../interfaces/governance_interface";

module {

  public type Result<X, Y> = Result.Result<X, Y>;

  public type NeuronId = Nat64;

  public type StakeNeuronResult = Result.Result<NeuronId, Text>;

  public type NeuronInfo = {
    neuronId : NeuronId;
    info : IcpGovernanceInterface.NeuronInfo;
  };

  public let ICP_PROTOCOL_FEE : Nat64 = 10_000;

  public let ONE_ICP : Nat64 = 100_000_000;

  public class NNS({
    canister_id : Principal;
    nns_canister_id : Principal;
    icp_ledger_canister_id : Principal;
  }) {

    let IcpLedger = actor (Principal.toText(icp_ledger_canister_id)) : IcpLedgerInterface.Self;

    let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

    public func stake({ amount : Nat64 }) : async StakeNeuronResult {
      if (amount < ONE_ICP + ICP_PROTOCOL_FEE) return #err("A minimum of 1.0001 ICP is needed to stake");

      // generate a random nonce that fits into Nat64
      let ?nonce = Random.Finite(await Random.blob()).range(64) else return #err("Failed to generate nonce");

      // controller is the canister
      let neuronController : Principal = canister_id;

      // neurons subaccounts contain random nonces so one controller can have many neurons
      let newSubaccount : Blob = computeNeuronStakingSubaccountBytes(neuronController, Nat64.fromNat(nonce));

      // the neuron account ID is a sub account of the governance canister
      let newNeuronAccount : Blob = AccountIdentifier.accountIdentifier(nns_canister_id, newSubaccount);

      switch (await IcpLedger.transfer({ memo = Nat64.fromNat(nonce); from_subaccount = null; to = newNeuronAccount; amount = { e8s = amount - ICP_PROTOCOL_FEE }; fee = { e8s = ICP_PROTOCOL_FEE }; created_at_time = null })) {
        case (#Ok _) {
          // ClaimOrRefresh: finds the neuron by subaccount and checks if the memo matches the nonce
          let { command } = await IcpGovernance.manage_neuron({
            id = null;
            neuron_id_or_subaccount = null;
            command = ? #ClaimOrRefresh({
              by = ? #MemoAndController({
                controller = ?neuronController;
                memo = Nat64.fromNat(nonce);
              });
            });
          });

          let ?commandList = command else return #err("Failed to claim new neuron");

          switch (commandList) {
            case (#ClaimOrRefresh { refreshed_neuron_id }) {

              let ?{ id } = refreshed_neuron_id else return #err("Failed to retrieve new neuron Id");

              return #ok(id);
            };
            case _ {
              return #err("Failed to stake. " # debug_show commandList);
            };
          };
        };
        case (#Err error) {
          return #err("Failed to transfer ICP: " # debug_show error);
        };
      };
    };

    public func getNeuronIds() : async [NeuronId] {
      return await IcpGovernance.get_neuron_ids();
    };

    // If an array of neuron IDs is provided, precisely those neurons will be fetched.
    // motoko version of this: https://github.com/dfinity/ic-js/tree/main/packages/nns#gear-listneurons
    public func listNeuronInfo({ neuronIds : ?[NeuronId] }) : async [NeuronInfo] {
      let buf = Buffer.Buffer<NeuronInfo>(0);

      let ids = Option.get(neuronIds, await getNeuronIds());

      for (id in ids.vals()) {
        switch (await IcpGovernance.get_neuron_info(id)) {
          case (#Ok info) {
            buf.add({ neuronId = id; info = info });
          };
          case _ { /* do nothing */ };
        };
      };

      return Buffer.toArray(buf);
    };

    // motoko version of this: https://github.com/dfinity/ic/blob/0f7973af4283f3244a08b87ea909b6f605d65989/rs/nervous_system/common/src/ledger.rs#L210
    private func computeNeuronStakingSubaccountBytes(controller : Principal, nonce : Nat64) : Blob {
      let hash = Sha256.Digest(#sha256);
      hash.writeArray([0x0c]);
      hash.writeArray(Blob.toArray(Text.encodeUtf8("neuron-stake")));
      hash.writeArray(Blob.toArray(Principal.toBlob(controller)));
      hash.writeArray(Binary.BigEndian.fromNat64(nonce)); // needs to be big endian bytes
      return hash.sum();
    };
  };

};
