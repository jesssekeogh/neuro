import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Nat64 "mo:base/Nat64";
import Tools "../tools";
import Types "../types";
import AccountIdentifier "mo:account-identifier";
import IcpLedgerInterface "../interfaces/icp_ledger_interface";
import IcpGovernanceInterface "../interfaces/nns_interface";

module {

  public class Governance({
    canister_id : Principal;
    nns_canister_id : Principal;
    icp_ledger_canister_id : Principal;
  }) {

    let IcpLedger = actor (Principal.toText(icp_ledger_canister_id)) : IcpLedgerInterface.Self;

    let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

    public func stake({ amount_e8s : Nat64 }) : async Types.NnsStakeNeuronResult {
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
            command = ? #ClaimOrRefresh({
              by = ? #MemoAndController({
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

    public func getNeuronIds() : async [Types.NnsNeuronId] {
      return await IcpGovernance.get_neuron_ids();
    };

    // If an array of neuron IDs is provided, precisely those neurons will be fetched.
    public func listNeurons({ neuronIds : [Types.NnsNeuronId] }) : async Types.NnsListNeuronsResponse {
      return await IcpGovernance.list_neurons({
        neuron_ids = neuronIds;
        include_neurons_readable_by_caller = true;
      });
    };
  };

  public class Neuron({
    neuron_id : Types.NnsNeuronId;
    nns_canister_id : Principal;
  }) {

    let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

    public func getInformation() : async Types.NnsInformationResult {
      switch (await IcpGovernance.get_neuron_info(neuron_id), await IcpGovernance.get_full_neuron(neuron_id)) {
        case (#Ok neuronInfo, #Ok neuron) {
          return #ok({
            age_seconds = neuronInfo.age_seconds;
            created_timestamp_seconds = neuronInfo.created_timestamp_seconds;
            dissolve_delay_seconds = neuronInfo.dissolve_delay_seconds;
            joined_community_fund_timestamp_seconds = neuronInfo.joined_community_fund_timestamp_seconds;
            known_neuron_data = neuronInfo.known_neuron_data;
            recent_ballots = neuronInfo.recent_ballots;
            retrieved_at_timestamp_seconds = neuronInfo.retrieved_at_timestamp_seconds;
            stake_e8s = neuronInfo.stake_e8s;
            state = neuronInfo.state;
            voting_power = neuronInfo.voting_power;
            account = neuron.account;
            aging_since_timestamp_seconds = neuron.aging_since_timestamp_seconds;
            cached_neuron_stake_e8s = neuron.cached_neuron_stake_e8s;
            controller = neuron.controller;
            dissolve_state = neuron.dissolve_state;
            followees = neuron.followees;
            hot_keys = neuron.hot_keys;
            id = neuron.id;
            kyc_verified = neuron.kyc_verified;
            maturity_e8s_equivalent = neuron.maturity_e8s_equivalent;
            neuron_fees_e8s = neuron.neuron_fees_e8s;
            not_for_profit = neuron.not_for_profit;
            spawn_at_timestamp_seconds = neuron.spawn_at_timestamp_seconds;
            transfer = neuron.transfer;
          });
        };
        case _ {
          return #err("Failed to fetch neuron information");
        };
      };
    };

    public func spawn({
      percentage_to_spawn : ?Nat32;
      new_controller : ?Principal;
    }) : async Types.NnsSpawnResult {
      return await manageNeuronSpawn(
        #Spawn({
          percentage_to_spawn = percentage_to_spawn;
          new_controller = new_controller;
          nonce = null;
        })
      );
    };

    public func split({ amount_e8s : Nat64 }) : async Types.NnsSpawnResult {
      return await manageNeuronSpawn(
        #Split({
          amount_e8s = amount_e8s;
        })
      );
    };

    public func disburse({ to_account : [Nat8] }) : async Types.CommandResult {
      return await manageNeuronCommand(
        #Disburse({
          to_account = ?{ hash = to_account };
          amount = null; // defaults to 100%
        })
      );
    };

    public func mergeMaturity({ percentage_to_merge : Nat32 }) : async Types.CommandResult {
      return await manageNeuronCommand(
        #MergeMaturity({
          percentage_to_merge = percentage_to_merge;
        })
      );
    };

    public func refresh() : async Types.CommandResult {
      return await manageNeuronCommand(
        #ClaimOrRefresh({
          by = ? #NeuronIdOrSubaccount({});
        })
      );
    };

    public func registerVote({ vote : Int32; proposal : Types.NnsNeuronId }) : async Types.CommandResult {
      return await manageNeuronCommand(
        #RegisterVote({
          vote = vote;
          proposal = ?{ id = proposal };
        })
      );
    };

    public func follow({ topic : Int32; followee : Types.NnsNeuronId }) : async Types.CommandResult {
      return await manageNeuronCommand(
        #Follow({
          topic = topic;
          followees = [{ id = followee }];
        })
      );
    };

    public func clearFollowees({ topic : Int32 }) : async Types.CommandResult {
      return await manageNeuronCommand(
        #Follow({
          topic = topic;
          followees = [];
        })
      );
    };

    public func increaseDissolveDelay({
      additional_dissolve_delay_seconds : Nat32;
    }) : async Types.ConfigureResult {
      return await manageNeuronConfiguration(
        #IncreaseDissolveDelay({
          additional_dissolve_delay_seconds = additional_dissolve_delay_seconds;
        })
      );
    };

    public func startDissolving() : async Types.ConfigureResult {
      return await manageNeuronConfiguration(
        #StartDissolving({})
      );
    };

    public func stopDissolving() : async Types.ConfigureResult {
      return await manageNeuronConfiguration(
        #StopDissolving({})
      );
    };

    public func addHotKey({ new_hot_key : Principal }) : async Types.ConfigureResult {
      return await manageNeuronConfiguration(
        #AddHotKey({
          new_hot_key = ?new_hot_key;
        })
      );
    };

    public func removeHotKey({ hot_key_to_remove : Principal }) : async Types.ConfigureResult {
      return await manageNeuronConfiguration(
        #RemoveHotKey({
          hot_key_to_remove = ?hot_key_to_remove;
        })
      );
    };

    private func manageNeuronConfiguration(operation : Types.NnsOperation) : async Types.ConfigureResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = ?{ id = neuron_id };
        neuron_id_or_subaccount = null;
        command = ? #Configure({ operation = ?operation });
      });

      let ?commandList = command else return #err("Failed to configure neuron. Neuron ID: " # debug_show neuron_id);

      switch (commandList) {
        case (#Configure _) { return #ok() };
        case _ {
          return #err("Configuration failed: " # debug_show commandList);
        };
      };
    };

    private func manageNeuronCommand(neuronCommand : Types.NnsCommand) : async Types.CommandResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = ?{ id = neuron_id };
        neuron_id_or_subaccount = null;
        command = ?neuronCommand;
      });

      let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id);

      switch (commandList) {
        case (#Error error) {
          return #err("Command failed: " # debug_show error);
        };
        case _ { return #ok() };
      };
    };

    private func manageNeuronSpawn(neuronCommand : Types.NnsCommand) : async Types.NnsSpawnResult {
      let { command } = await IcpGovernance.manage_neuron({
        id = ?{ id = neuron_id };
        neuron_id_or_subaccount = null;
        command = ?neuronCommand;
      });

      let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id);

      switch (commandList) {
        case (#Spawn { created_neuron_id }) {

          let ?{ id } = created_neuron_id else return #err("Failed to retrieve new neuron Id");

          return #ok(id);
        };
        case (#Split { created_neuron_id }) {

          let ?{ id } = created_neuron_id else return #err("Failed to retrieve new neuron Id");

          return #ok(id);
        };
        case _ {
          return #err("Command failed: " # debug_show commandList);
        };
      };
    };
  };

};
