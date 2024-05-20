import { NNS; SNS } "../../src";
import NeuroTypes "../../src/types";
// in production you can use destructuring assignment syntax like:

// import { NNS; SNS; } "mo:neuro";

// or use a namespace import like:

// import Neuro "mo:neuro";

import Principal "mo:base/Principal";
import Result "mo:base/Result";

shared actor class Test() = thisCanister {

    stable var _snsneuron : ?NeuroTypes.SnsNeuronId = null;

    public func stake_sns_neuron() : async Result.Result<Blob, Text> {
        // OpenChat SNS configuration:
        let sns = SNS.SNS({
            canister_id = Principal.fromActor(thisCanister);
            sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
            sns_ledger_canister_id = Principal.fromText("2ouva-viaaa-aaaaq-aaamq-cai");
        });

        switch (await sns.stake({ amount = 10_000 })) {
            case (#ok result) {
                _snsneuron := ?result;
                return #ok(result);
            };
            case (#err result) {
                return #err(result);
            };
        };
    };

    public func get_sns_neuron_information() : async Result.Result<NeuroTypes.SnsNeuronInformation, Text> {
        let ?snsneuron = _snsneuron else return #err("SNS neuron id not found");

        let neuron = SNS.Neuron({
            neuron_id = snsneuron;
            sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
        });

        return await neuron.getInformation();
    };

};
