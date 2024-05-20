import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Random "mo:base/Random";
import Nat64 "mo:base/Nat64";
import Nat32 "mo:base/Nat32";
import Sha256 "mo:sha2/Sha256";
import Binary "mo:encoding/Binary";
import SnsLedgerInterface "../interfaces/sns_ledger_interface";
import SnsGovernanceInterface "../interfaces/sns_interface";

module {

    public type Result<X, Y> = Result.Result<X, Y>;

    public type NeuronId = Blob;

    public type StakeNeuronResult = Result.Result<NeuronId, Text>;

    public type Neuron = SnsGovernanceInterface.Neuron;

    public class SNS({
        canister_id : Principal;
        sns_canister_id : Principal;
        sns_ledger_canister_id : Principal;
    }) {

        let SnsLedger = actor (Principal.toText(sns_ledger_canister_id)) : SnsLedgerInterface.Self;

        let SnsGovernance = actor (Principal.toText(sns_canister_id)) : SnsGovernanceInterface.Self;

        public func stake({ amount : Nat }) : async StakeNeuronResult {
            // generate a random nonce that fits into Nat64
            let ?nonce = Random.Finite(await Random.blob()).range(64) else return #err("Failed to generate nonce");

            // controller is the canister
            let neuronController : Principal = canister_id;

            // neurons subaccounts contain random nonces so one controller can have many neurons
            let newSubaccount : Blob = computeNeuronStakingSubaccountBytes(neuronController, Nat64.fromNat(nonce));

            switch (await SnsLedger.icrc1_transfer({ to = { owner = sns_canister_id; subaccount = ?newSubaccount }; fee = null; memo = null; from_subaccount = null; created_at_time = null; amount = amount })) {
                case (#Ok _) {
                    // ClaimOrRefresh: finds the neuron and claims it
                    let { command } = await SnsGovernance.manage_neuron({
                        subaccount = newSubaccount;
                        command = ? #ClaimOrRefresh({ by = ? #NeuronId({}) });
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
                    return #err("Failed to transfer amount: " # debug_show error);
                };
            };
        };

        public func listNeurons() : async [Neuron] {
            let { neurons } = await SnsGovernance.list_neurons({
                of_principal = ?canister_id;
                limit = Nat32.maximumValue;
                start_page_at = null;
            });

            return neurons;
        };
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
