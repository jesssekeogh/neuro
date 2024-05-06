import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import IcpGovernanceInterface "../interfaces/governance_interface";

module {

    public type Result<X, Y> = Result.Result<X, Y>;

    public type ConfigureResult = Result<(), Text>;

    public type SpawnResult = Result<NeuronId, Text>;

    public type InformationResult = Result<Information, Text>;

    public type NeuronId = Nat64;

    public type Information = IcpGovernanceInterface.NeuronInfo and IcpGovernanceInterface.Neuron;

    public class Neuron({ neuron_id : Nat64; nns_canister_id : Principal }) {

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

        public func increaseDissolveDelay({
            additional_dissolve_delay_seconds : Nat32;
        }) : async ConfigureResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Configure({
                    operation = ? #IncreaseDissolveDelay({
                        additional_dissolve_delay_seconds = additional_dissolve_delay_seconds;
                    });
                });
            });

            let ?commandList = command else return #err("Failed to increase neuron dissolve delay");

            switch (commandList) {
                case (#Configure _) { return #ok() };
                case _ {
                    return #err("Failed to increase neuron dissolve delay. " # debug_show commandList);
                };
            };
        };

        public func follow({ topic : Int32; followee : NeuronId }) : async ConfigureResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Follow({
                    topic = topic;
                    followees = [{ id = followee }];
                });
            });

            let ?commandList = command else return #err("Failed to set neuron followee");

            switch (commandList) {
                case (#Follow _) { return #ok() };
                case _ {
                    return #err("Failed to set neuron followee. " # debug_show commandList);
                };
            };
        };

        public func split({ amount_e8s : Nat64 }) : async SpawnResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Split({ amount_e8s = amount_e8s });
            });

            let ?commandList = command else return #err("Failed to split new neuron");

            switch (commandList) {
                case (#Split { created_neuron_id }) {

                    let ?{ id } = created_neuron_id else return #err("Failed to retrieve new neuron Id");

                    return #ok(id);
                };
                case _ {
                    return #err("Failed to split new neuron. " # debug_show commandList);
                };
            };
        };

        public func spawn({
            percentage_to_spawn : ?Nat32;
            new_controller : ?Principal;
        }) : async SpawnResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Spawn({
                    percentage_to_spawn = percentage_to_spawn;
                    new_controller = new_controller;
                    nonce = null;
                });
            });

            let ?commandList = command else return #err("Failed to spawn new neuron");

            switch (commandList) {
                case (#Spawn { created_neuron_id }) {

                    let ?{ id } = created_neuron_id else return #err("Failed to retrieve new neuron Id");

                    return #ok(id);
                };
                case _ {
                    return #err("Failed to spawn new neuron. " # debug_show commandList);
                };
            };
        };

        public func startDissolving() : async ConfigureResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Configure({ operation = ? #StartDissolving({}) });
            });

            let ?commandList = command else return #err("Failed to start dissolving neuron");

            switch (commandList) {
                case (#Configure _) { return #ok() };
                case _ {
                    return #err("Failed to start dissolving neuron. " # debug_show commandList);
                };
            };
        };

        public func disburse({ to_account : [Nat8] }) : async ConfigureResult {
            let { command } = await IcpGovernance.manage_neuron({
                id = ?{ id = neuron_id };
                neuron_id_or_subaccount = null;
                command = ? #Disburse({
                    to_account = ?{
                        hash = to_account;
                    };
                    amount = null; // defaults to 100%
                });
            });

            let ?commandList = command else return #err("Failed to disburse neuron");

            switch (commandList) {
                case (#Disburse _) { return #ok() };
                case _ {
                    return #err("Failed to disburse neuron. " # debug_show commandList);
                };
            };
        };

    };

};
