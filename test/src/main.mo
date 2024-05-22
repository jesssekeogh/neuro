import { NNS; SNS } "../../src";
import NeuroTypes "../../src/types";

// in production you can use destructuring assignment syntax like:
// import { NNS; SNS; } "mo:neuro";

// or use a namespace import like:
// import Neuro "mo:neuro";

import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Hex "mo:encoding/Hex";
import AccountIdentifier "mo:account-identifier";
import SnsLedgerInterface "../../src/interfaces/sns_ledger_interface";
import IcpLedgerInterface "../../src/interfaces/icp_ledger_interface";

actor class Test() = thisCanister {

    ///////////////////////////////////
    /// SNS Neuron Staking Example: ///
    ///////////////////////////////////

    public func stake_sns_neuron() : async Result.Result<Blob, Text> {
        // OpenChat SNS configuration:
        let sns = SNS.SNS({
            canister_id = Principal.fromActor(thisCanister);
            sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
            sns_ledger_canister_id = Principal.fromText("2ouva-viaaa-aaaaq-aaamq-cai");
        });

        // The minimum stake for $CHAT is 400_000_000 e8s.
        // The fee for $CHAT transactions is 100_000 e8s.
        // These values can be obtained by calling the get_nervous_system_parameters and icrc1_fee functions.
        switch (await sns.stake({ amount = 400_000_000 })) {
            case (#ok result) {
                return #ok(result);
            };
            case (#err result) {
                return #err(result);
            };
        };
    };

    public func list_sns_neurons() : async [NeuroTypes.SnsNeuronInformation] {
        let sns = SNS.SNS({
            canister_id = Principal.fromActor(thisCanister);
            sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
            sns_ledger_canister_id = Principal.fromText("2ouva-viaaa-aaaaq-aaamq-cai");
        });

        return await sns.listNeurons();
    };

    ///////////////////////////////////
    /// ICP Neuron Staking Example: ///
    ///////////////////////////////////

    // TODO

    //////////////////////////////////////////
    /// Example canister wallet functions: ///
    //////////////////////////////////////////

    public query func get_canister_wallet_information() : async {
        icrc_account : Text;
        icp_legacy_account : Text;
    } {
        return {
            icrc_account = Principal.fromActor(thisCanister) |> Principal.toText(_);
            icp_legacy_account = Principal.fromActor(thisCanister) |> AccountIdentifier.accountIdentifier(_, AccountIdentifier.defaultSubaccount()) |> Blob.toArray(_) |> Hex.encode(_);
        };
    };

    public func get_canister_wallet_balances() : async {
        chat_balance : Nat;
        icp_balance : Nat;
    } {
        let openchatLedger = actor "2ouva-viaaa-aaaaq-aaamq-cai" : SnsLedgerInterface.Self;
        let icpLedger = actor "ryjl3-tyaaa-aaaaa-aaaba-cai" : IcpLedgerInterface.Self;

        let chatBalance = await openchatLedger.icrc1_balance_of({
            owner = Principal.fromActor(thisCanister);
            subaccount = null;
        });

        let icpBalance = await icpLedger.icrc1_balance_of({
            owner = Principal.fromActor(thisCanister);
            subaccount = null;
        });

        return { chat_balance = chatBalance; icp_balance = icpBalance };
    };
};
