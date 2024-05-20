import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import SnsGovernanceInterface "../interfaces/sns_interface";

module {

    public type Result<X, Y> = Result.Result<X, Y>;

    public type Information = SnsGovernanceInterface.Neuron;

    public type ConfigureResult = Result<(), Text>;

    public type CommandResult = Result<(), Text>;

    public type DisburseMaturityResponse = SnsGovernanceInterface.DisburseMaturityResponse;

    public type Account = SnsGovernanceInterface.Account;

    public type DisburseMaturityResult = Result<DisburseMaturityResponse, Text>;

    public type SplitResult = Result<NeuronId, Text>;

    public type InformationResult = Result<Information, Text>;

    public type NeuronId = Blob;

    public type Operation = SnsGovernanceInterface.Operation;

    public type Command = SnsGovernanceInterface.Command;

    public class Neuron({ neuron_id : NeuronId; sns_canister_id : Principal }) {

        let SnsGovernance = actor (Principal.toText(sns_canister_id)) : SnsGovernanceInterface.Self;

        public func getInformation() : async InformationResult {
            let { result } = await SnsGovernance.get_neuron({
                neuron_id = ?{ id = neuron_id };
            });

            switch (result) {
                case (? #Neuron neuron) {
                    return #ok(neuron);
                };
                case _ {
                    return #err("Failed to fetch neuron information");
                };
            };
        };

        public func disburseMaturity({
            percentage_to_disburse : Nat32;
            to_account : ?Account;
        }) : async DisburseMaturityResult {
            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
                command = ? #DisburseMaturity({
                    to_account = to_account;
                    percentage_to_disburse = percentage_to_disburse;
                });
            });

            let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id);

            switch (commandList) {
                case (#DisburseMaturity result) {
                    return #ok(result);
                };
                case _ {
                    return #err("Command failed: " # debug_show commandList);
                };
            };
        };

        public func split({ memo : Nat64; amount_e8s : Nat64 }) : async SplitResult {
            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
                command = ? #Split({
                    memo = memo;
                    amount_e8s = amount_e8s;
                });
            });

            let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id);

            switch (commandList) {
                case (#Split { created_neuron_id }) {

                    let ?{ id } = created_neuron_id else return #err("Failed to retrieve new neuron Id");

                    return #ok(id);
                };
                case _ {
                    return #err("Command failed: " # debug_show commandList);
                };
            };
        };

        public func disburse({ to_account : Account }) : async CommandResult {
            return await manageNeuronCommand(
                #Disburse({
                    to_account = ?to_account;
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
                    by = ? #NeuronId({});
                })
            );
        };

        public func registerVote({ vote : Int32; proposal : Nat64 }) : async CommandResult {
            return await manageNeuronCommand(
                #RegisterVote({
                    vote = vote;
                    proposal = ?{ id = proposal };
                })
            );
        };

        public func follow({ function_id : Nat64; followee : NeuronId }) : async CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    function_id = function_id;
                    followees = [{ id = followee }];
                })
            );
        };

        public func clearFollowees({ function_id : Nat64 }) : async CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    function_id = function_id;
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

        private func manageNeuronConfiguration(operation : Operation) : async ConfigureResult {
            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
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
            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
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
    };

};
