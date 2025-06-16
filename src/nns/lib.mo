import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Nat64 "mo:base/Nat64";
import Tools "../tools";
import Types "../types";
import AccountIdentifier "mo:account-identifier";
import IcpLedgerInterface "../interfaces/icp_ledger_interface";
import IcpGovernanceInterface "../interfaces/nns_interface";

// The NNS was developed first and is older than the SNS.
// There are differences in how some of the functions and types are structured.
// Therefore, note that this does not match the format and layout of the SNS governance and neuron classes in this package.
// However, the interfaces are largely similar.

module {

  /////////////////////////////
  /// NNS Governance Class: ///
  /////////////////////////////

  public class Governance({
    canister_id : Principal;
    nns_canister_id : Principal;
    icp_ledger_canister_id : Principal;
  }) {

    let IcpLedger = actor (Principal.toText(icp_ledger_canister_id)) : IcpLedgerInterface.Self;

    let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

    // Helper function that performs the necessary operations to stake a neuron in a canister.
    // It is not recommended to use this function in production, as failures may occur.
    // This is provided for demonstration purposes only.
    // Instead, use your own staking flow and refer to the claimNeuron function below.
    // Note: The NNS staking function relies on the legacy ICP ledger transfer and memo.
    public func stake({ amount_e8s : Nat64 }) : async* Types.NnsStakeNeuronResult {
      // generate a random nonce that fits into Nat64
      let ?nonce = Random.Finite(await Random.blob()).range(64) else return #err("Failed to generate nonce");

      let convertedNonce = Nat64.fromNat(nonce);

      // controller is the canister
      let neuronController : Principal = canister_id;

      // neurons subaccounts contain random nonces so one controller can have many neurons
      let newSubaccount : Blob = Tools.computeNeuronStakingSubaccountBytes(neuronController, convertedNonce);

      // the neuron account ID is a sub account of the governance canister
      let newNeuronAccount : Blob = AccountIdentifier.accountIdentifier(nns_canister_id, newSubaccount);

      switch (await IcpLedger.transfer({ memo = convertedNonce; from_subaccount = null; to = newNeuronAccount; amount = { e8s = amount_e8s }; fee = { e8s = 10_000 }; created_at_time = null })) {
        case (#Ok _) {
          // ClaimOrRefresh: finds the neuron by subaccount and checks if the memo matches the nonce
          let { command } = await IcpGovernance.manage_neuron({
            id = null;
            neuron_id_or_subaccount = null;
            command = ?#ClaimOrRefresh({
              by = ?#MemoAndController({
                controller = ?neuronController;
                memo = convertedNonce;
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
          return #err("Failed to transfer amount: " # debug_show error);
        };
      };
    };

    // if you want to generate your own nonces or transfer ICP from somewhere else, this is useful
    public func claimNeuron({ nonce : Nat64 }) : async* Types.NnsSpawnResult {
      let neuronController : Principal = canister_id;

      let { command } = await IcpGovernance.manage_neuron({
        id = null;
        neuron_id_or_subaccount = null;
        command = ?#ClaimOrRefresh({
          by = ?#MemoAndController({
            controller = ?neuronController;
            memo = nonce;
          });
        });
      });

      let ?commandList = command else return #err(null);

      switch (commandList) {
        case (#ClaimOrRefresh { refreshed_neuron_id }) {

          let ?{ id } = refreshed_neuron_id else return #err(null);

          return #ok(id);
        };
        case (#Error(error)) {
          return #err(?error);
        };
        case _ {
          return #err(null);
        };
      };
    };

    // returns the neurons that the canister controls
    public func getNeuronIds() : async* [Types.NnsNeuronId] {
      return await IcpGovernance.get_neuron_ids();
    };

    // If an array of neuron IDs is provided, precisely those neurons will be fetched.
    public func listNeurons({
      neuron_ids : [Types.NnsNeuronId];
      include_readable : Bool;
      include_empty : Bool;
      include_public : Bool;
      page_size : ?Nat64;
      page_number : ?Nat64;
      neuron_subaccounts : ?[Types.NnsNeuronSubaccount];
    }) : async* Types.NnsListNeuronsResponse {
      return await IcpGovernance.list_neurons({
        page_size = page_size;
        include_public_neurons_in_full_neurons = ?include_public;
        neuron_ids = neuron_ids;
        page_number = page_number;
        include_empty_neurons_readable_by_caller = ?include_empty;
        neuron_subaccounts = neuron_subaccounts;
        include_neurons_readable_by_caller = include_readable;
      });
    };
  };

  /////////////////////////
  /// NNS Neuron Class: ///
  /////////////////////////

  public class Neuron({
    neuron_id_or_subaccount : Types.NnsNeuronIdOrSubaccount;
    nns_canister_id : Principal;
  }) {

    let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

    public func getInformation() : async* Types.NnsInformationResult {
      switch (await IcpGovernance.get_full_neuron_by_id_or_subaccount(neuron_id_or_subaccount)) {
        case (#Ok neuron) {
          return #ok(neuron);
        };
        case _ {
          return #err("Failed to fetch neuron information");
        };
      };
    };

    // deprecated, use disburseMaturity instead
    public func spawn({
      percentage_to_spawn : ?Nat32;
      new_controller : ?Principal;
      nonce : ?Nat64;
    }) : async* Types.NnsSpawnResult {
      return await* manageNeuronSpawn(
        #Spawn({
          percentage_to_spawn = percentage_to_spawn;
          new_controller = new_controller;
          nonce = nonce;
        })
      );
    };

    public func disburseMaturity({
      to_account_identifier : ?{ hash : Blob };
      to_account : ?Types.NnsAccount;
      percentage_to_disburse : Nat32;
    }) : async* Types.NnsDisburseMaturityResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = null;
        neuron_id_or_subaccount = ?neuron_id_or_subaccount;
        command = ?#DisburseMaturity({
          to_account_identifier = to_account_identifier;
          to_account = to_account;
          percentage_to_disburse = percentage_to_disburse;
        });
      });

      let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id_or_subaccount);

      switch (commandList) {
        case (#DisburseMaturity result) {
          return #ok(result);
        };
        case _ {
          return #err("Command failed: " # debug_show commandList);
        };
      };
    };

    public func split({ amount_e8s : Nat64 }) : async* Types.NnsSpawnResult {
      return await* manageNeuronSpawn(
        #Split({
          amount_e8s = amount_e8s;
        })
      );
    };

    public func disburse({
      to_account : ?{ hash : Blob };
      amount : ?{ e8s : Nat64 };
    }) : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #Disburse({
          to_account = to_account;
          amount = amount;
        })
      );
    };

    public func mergeMaturity({ percentage_to_merge : Nat32 }) : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #MergeMaturity({
          percentage_to_merge = percentage_to_merge;
        })
      );
    };

    public func refreshVotingPower() : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #RefreshVotingPower({})
      );
    };

    public func refresh() : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #ClaimOrRefresh({
          by = ?#NeuronIdOrSubaccount({});
        })
      );
    };

    public func registerVote({ vote : Int32; proposal : Types.NnsNeuronId }) : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #RegisterVote({
          vote = vote;
          proposal = ?{ id = proposal };
        })
      );
    };

    public func follow({ topic : Int32; followee : Types.NnsNeuronId }) : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #Follow({
          topic = topic;
          followees = [{ id = followee }];
        })
      );
    };

    public func clearFollowees({ topic : Int32 }) : async* Types.CommandResult {
      return await* manageNeuronCommand(
        #Follow({
          topic = topic;
          followees = [];
        })
      );
    };

    public func increaseDissolveDelay({
      additional_dissolve_delay_seconds : Nat32;
    }) : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #IncreaseDissolveDelay({
          additional_dissolve_delay_seconds = additional_dissolve_delay_seconds;
        })
      );
    };

    public func setDissolveTimestamp({
      dissolve_timestamp_seconds : Nat64;
    }) : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #SetDissolveTimestamp({
          dissolve_timestamp_seconds = dissolve_timestamp_seconds;
        })
      );
    };

    public func startDissolving() : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #StartDissolving({})
      );
    };

    public func stopDissolving() : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #StopDissolving({})
      );
    };

    public func addHotKey({ new_hot_key : Principal }) : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #AddHotKey({
          new_hot_key = ?new_hot_key;
        })
      );
    };

    public func removeHotKey({ hot_key_to_remove : Principal }) : async* Types.ConfigureResult {
      return await* manageNeuronConfiguration(
        #RemoveHotKey({
          hot_key_to_remove = ?hot_key_to_remove;
        })
      );
    };

    private func manageNeuronConfiguration(operation : Types.NnsOperation) : async* Types.ConfigureResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = null;
        neuron_id_or_subaccount = ?neuron_id_or_subaccount;
        command = ?#Configure({ operation = ?operation });
      });

      let ?commandList = command else return #err(null);

      // only check for an error, every other result is presumed okay
      // a trap would not be included in the "_" and still fail
      switch (commandList) {
        case (#Error(error)) {
          return #err(?error);
        };
        case (_) { return #ok() };
      };
    };

    private func manageNeuronCommand(neuronCommand : Types.NnsCommand) : async* Types.CommandResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = null;
        neuron_id_or_subaccount = ?neuron_id_or_subaccount;
        command = ?neuronCommand;
      });

      let ?commandList = command else return #err(null);

      switch (commandList) {
        case (#Error error) {
          return #err(?error);
        };
        case _ { return #ok() };
      };
    };

    private func manageNeuronSpawn(neuronCommand : Types.NnsCommand) : async* Types.NnsSpawnResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = null;
        neuron_id_or_subaccount = ?neuron_id_or_subaccount;
        command = ?neuronCommand;
      });

      let ?commandList = command else return #err(null);

      switch (commandList) {
        case (#Spawn { created_neuron_id }) {

          let ?{ id } = created_neuron_id else return #err(null);

          return #ok(id);
        };
        case (#Split { created_neuron_id }) {

          let ?{ id } = created_neuron_id else return #err(null);

          return #ok(id);
        };
        case (#Error(error)) {
          return #err(?error);
        };
        case _ {
          return #err(null);
        };
      };
    };
  };

};
