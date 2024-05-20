import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import IcpGovernanceInterface "../interfaces/nns_interface";

module {

    public type Result<X, Y> = Result.Result<X, Y>;

    public type ConfigureResult = Result<(), Text>;

    public type CommandResult = Result<(), Text>;

    public type SpawnResult = Result<NeuronId, Text>;

    public type InformationResult = Result<Information, Text>;

    public type NeuronId = Nat64;

    public type Operation = IcpGovernanceInterface.Operation;

    public type Command = IcpGovernanceInterface.Command;

    public type Information = IcpGovernanceInterface.NeuronInfo and IcpGovernanceInterface.Neuron;

    public class Neuron({ neuron_id : NeuronId; nns_canister_id : Principal }) {

        let IcpGovernance = actor (Principal.toText(nns_canister_id)) : IcpGovernanceInterface.Self;

        public func getInformation() : async InformationResult {
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
        }) : async SpawnResult {
            return await manageNeuronSpawn(
                #Spawn({
                    percentage_to_spawn = percentage_to_spawn;
                    new_controller = new_controller;
                    nonce = null;
                })
            );
        };

        public func split({ amount_e8s : Nat64 }) : async SpawnResult {
            return await manageNeuronSpawn(
                #Split({
                    amount_e8s = amount_e8s;
                })
            );
        };

        public func disburse({ to_account : [Nat8] }) : async CommandResult {
            return await manageNeuronCommand(
                #Disburse({
                    to_account = ?{ hash = to_account };
                    amount = null; // defaults to 100%
                })
            );
        };

        public func mergeMaturity({ percentage_to_merge : Nat32 }) : async CommandResult {
            return await manageNeuronCommand(
                #MergeMaturity({
                    percentage_to_merge = percentage_to_merge;
                })
            );
        };

        public func refresh() : async CommandResult {
            return await manageNeuronCommand(
                #ClaimOrRefresh({
                    by = ? #NeuronIdOrSubaccount({});
                })
            );
        };

        public func registerVote({ vote : Int32; proposal : NeuronId }) : async CommandResult {
            return await manageNeuronCommand(
                #RegisterVote({
                    vote = vote;
                    proposal = ?{ id = proposal };
                })
            );
        };

        public func follow({ topic : Int32; followee : NeuronId }) : async CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    topic = topic;
                    followees = [{ id = followee }];
                })
            );
        };

        public func clearFollowees({ topic : Int32 }) : async CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    topic = topic;
                    followees = [];
                })
            );
        };

        public func increaseDissolveDelay({
            additional_dissolve_delay_seconds : Nat32;
        }) : async ConfigureResult {
            return await manageNeuronConfiguration(
                #IncreaseDissolveDelay({
                    additional_dissolve_delay_seconds = additional_dissolve_delay_seconds;
                })
            );
        };

        public func startDissolving() : async ConfigureResult {
            return await manageNeuronConfiguration(
                #StartDissolving({})
            );
        };

        public func stopDissolving() : async ConfigureResult {
            return await manageNeuronConfiguration(
                #StopDissolving({})
            );
        };

        public func addHotKey({ new_hot_key : Principal }) : async ConfigureResult {
            return await manageNeuronConfiguration(
                #AddHotKey({
                    new_hot_key = ?new_hot_key;
                })
            );
        };

        public func removeHotKey({ hot_key_to_remove : Principal }) : async ConfigureResult {
            return await manageNeuronConfiguration(
                #RemoveHotKey({
                    hot_key_to_remove = ?hot_key_to_remove;
                })
            );
        };

        private func manageNeuronConfiguration(operation : Operation) : async ConfigureResult {
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

        private func manageNeuronCommand(neuronCommand : Command) : async CommandResult {
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

        private func manageNeuronSpawn(neuronCommand : Command) : async SpawnResult {
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
