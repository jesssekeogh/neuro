import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Nat64 "mo:base/Nat64";
import Nat32 "mo:base/Nat32";
import Tools "../tools";
import Types "../types";
import Blob "mo:base/Blob";
import Binary "mo:encoding/Binary";
import SnsLedgerInterface "../interfaces/sns_ledger_interface";
import SnsGovernanceInterface "../interfaces/sns_interface";

module {

    /////////////////////////////
    /// SNS Governance Class: ///
    /////////////////////////////

    public class Governance({
        canister_id : Principal;
        sns_canister_id : Principal;
        sns_ledger_canister_id : Principal;
    }) {

        let SnsLedger = actor (Principal.toText(sns_ledger_canister_id)) : SnsLedgerInterface.Self;

        let SnsGovernance = actor (Principal.toText(sns_canister_id)) : SnsGovernanceInterface.Self;

        public func stake({ amount_e8s : Nat }) : async Types.SnsStakeNeuronResult {
            // generate a random nonce that fits into Nat64
            let ?nonce = Random.Finite(await Random.blob()).range(64) else return #err("Failed to generate nonce");

            let convertedNonce = Nat64.fromNat(nonce);

            // controller is the canister
            let neuronController : Principal = canister_id;

            // neurons subaccounts contain random nonces so one controller can have many neurons
            let newSubaccount : Blob = Tools.computeNeuronStakingSubaccountBytes(neuronController, convertedNonce);

            // convert the memo to blob for the icrc standard
            let memo = convertedNonce |> Binary.BigEndian.fromNat64(_) |> Blob.fromArray(_);

            switch (await SnsLedger.icrc1_transfer({ to = { owner = sns_canister_id; subaccount = ?newSubaccount }; fee = null; memo = ?memo; from_subaccount = null; created_at_time = null; amount = amount_e8s })) {
                case (#Ok _) {
                    // ClaimOrRefresh: finds the neuron and claims it
                    let { command } = await SnsGovernance.manage_neuron({
                        subaccount = newSubaccount;
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

        // returns the neurons that the canister controls
        public func listNeurons() : async [Types.SnsNeuronInformation] {
            let { neurons } = await SnsGovernance.list_neurons({
                of_principal = ?canister_id;
                limit = Nat32.maximumValue;
                start_page_at = null;
            });

            return neurons;
        };

        // returns the parameters of the SNS
        // this is necessary to find out the minimum stake and transaction fee of the SNS
        // this varies across different SNS's so it is exposed here
        public func getParameters() : async Types.SnsParameters {
            return await SnsGovernance.get_nervous_system_parameters(null);
        };
    };

    /////////////////////////
    /// SNS Neuron Class: ///
    /////////////////////////

    public class Neuron({
        neuron_id : Types.SnsNeuronId;
        sns_canister_id : Principal;
    }) {

        let SnsGovernance = actor (Principal.toText(sns_canister_id)) : SnsGovernanceInterface.Self;

        public func getInformation() : async Types.SnsInformationResult {
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
            to_account : ?Types.SnsAccount;
        }) : async Types.SnsDisburseMaturityResult {
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

        public func split({ amount_e8s : Nat64 }) : async Types.SnsSplitResult {
            // for the SNS split function nonce is generated randomly for you
            // on the nns UI the nonce is an accumulating number generated by the UI
            // for canisters and this package a simple approach is taken here:
            let ?nonce = Random.Finite(await Random.blob()).range(64) else return #err("Failed to generate nonce");

            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
                command = ? #Split({
                    memo = Nat64.fromNat(nonce); // Memo should be random
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

        public func disburse({
            to_account : ?Types.SnsAccount;
            amount : ?{ e8s : Nat64 };
        }) : async Types.CommandResult {
            return await manageNeuronCommand(
                #Disburse({
                    to_account = to_account;
                    amount = amount;
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
                    by = ? #NeuronId({});
                })
            );
        };

        public func registerVote({ vote : Int32; proposal : Nat64 }) : async Types.CommandResult {
            return await manageNeuronCommand(
                #RegisterVote({
                    vote = vote;
                    proposal = ?{ id = proposal };
                })
            );
        };

        public func follow({ function_id : Nat64; followee : Types.SnsNeuronId }) : async Types.CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    function_id = function_id;
                    followees = [{ id = followee }];
                })
            );
        };

        public func clearFollowees({ function_id : Nat64 }) : async Types.CommandResult {
            return await manageNeuronCommand(
                #Follow({
                    function_id = function_id;
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

        private func manageNeuronConfiguration(operation : Types.SnsOperation) : async Types.ConfigureResult {
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

        private func manageNeuronCommand(neuronCommand : Types.SnsCommand) : async Types.CommandResult {
            let { command } = await SnsGovernance.manage_neuron({
                subaccount = neuron_id;
                command = ?neuronCommand;
            });

            let ?commandList = command else return #err("Failed to execute neuron command. Neuron ID: " # debug_show neuron_id);

            // only check for an error, every other result is presumed okay
            // a trap would not be included in the "_" and still fail
            switch (commandList) {
                case (#Error error) {
                    return #err("Command failed: " # debug_show error);
                };
                case _ { return #ok() };
            };
        };
    };

};
