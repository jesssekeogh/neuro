module {
    public type AddWasmRequest = { hash : Blob; wasm : ?SnsWasm };
    public type AddWasmResponse = { result : ?Result };
    public type AirdropDistribution = { airdrop_neurons : [NeuronDistribution] };
    public type Canister = { id : ?Principal };
    public type Countries = { iso_codes : [Text] };
    public type DappCanisters = { canisters : [Canister] };
    public type DappCanistersTransferResult = {
        restored_dapp_canisters : [Canister];
        nns_controlled_dapp_canisters : [Canister];
        sns_controlled_dapp_canisters : [Canister];
    };
    public type DeployNewSnsRequest = { sns_init_payload : ?SnsInitPayload };
    public type DeployNewSnsResponse = {
        dapp_canisters_transfer_result : ?DappCanistersTransferResult;
        subnet_id : ?Principal;
        error : ?SnsWasmError;
        canisters : ?SnsCanisterIds;
    };
    public type DeployedSns = {
        root_canister_id : ?Principal;
        governance_canister_id : ?Principal;
        index_canister_id : ?Principal;
        swap_canister_id : ?Principal;
        ledger_canister_id : ?Principal;
    };
    public type DeveloperDistribution = {
        developer_neurons : [NeuronDistribution];
    };
    public type FractionalDeveloperVotingPower = {
        treasury_distribution : ?TreasuryDistribution;
        developer_distribution : ?DeveloperDistribution;
        airdrop_distribution : ?AirdropDistribution;
        swap_distribution : ?SwapDistribution;
    };
    public type GetAllowedPrincipalsResponse = {
        allowed_principals : [Principal];
    };
    public type GetDeployedSnsByProposalIdRequest = { proposal_id : Nat64 };
    public type GetDeployedSnsByProposalIdResponse = {
        get_deployed_sns_by_proposal_id_result : ?GetDeployedSnsByProposalIdResult;
    };
    public type GetDeployedSnsByProposalIdResult = {
        #Error : SnsWasmError;
        #DeployedSns : DeployedSns;
    };
    public type GetNextSnsVersionRequest = {
        governance_canister_id : ?Principal;
        current_version : ?SnsVersion;
    };
    public type GetNextSnsVersionResponse = { next_version : ?SnsVersion };
    public type GetProposalIdThatAddedWasmRequest = { hash : Blob };
    public type GetProposalIdThatAddedWasmResponse = { proposal_id : ?Nat64 };
    public type GetSnsSubnetIdsResponse = { sns_subnet_ids : [Principal] };
    public type GetWasmMetadataRequest = { hash : ?Blob };
    public type GetWasmMetadataResponse = { result : ?Result_1 };
    public type GetWasmRequest = { hash : Blob };
    public type GetWasmResponse = { wasm : ?SnsWasm };
    public type IdealMatchedParticipationFunction = {
        serialized_representation : ?Text;
    };
    public type InitialTokenDistribution = {
        #FractionalDeveloperVotingPower : FractionalDeveloperVotingPower;
    };
    public type InsertUpgradePathEntriesRequest = {
        upgrade_path : [SnsUpgrade];
        sns_governance_canister_id : ?Principal;
    };
    public type InsertUpgradePathEntriesResponse = { error : ?SnsWasmError };
    public type LinearScalingCoefficient = {
        slope_numerator : ?Nat64;
        intercept_icp_e8s : ?Nat64;
        from_direct_participation_icp_e8s : ?Nat64;
        slope_denominator : ?Nat64;
        to_direct_participation_icp_e8s : ?Nat64;
    };
    public type ListDeployedSnsesResponse = { instances : [DeployedSns] };
    public type ListUpgradeStep = {
        pretty_version : ?PrettySnsVersion;
        version : ?SnsVersion;
    };
    public type ListUpgradeStepsRequest = {
        limit : Nat32;
        starting_at : ?SnsVersion;
        sns_governance_canister_id : ?Principal;
    };
    public type ListUpgradeStepsResponse = { steps : [ListUpgradeStep] };
    public type MetadataSection = {
        contents : ?Blob;
        name : ?Text;
        visibility : ?Text;
    };
    public type NeuronBasketConstructionParameters = {
        dissolve_delay_interval_seconds : Nat64;
        count : Nat64;
    };
    public type NeuronDistribution = {
        controller : ?Principal;
        dissolve_delay_seconds : Nat64;
        memo : Nat64;
        stake_e8s : Nat64;
        vesting_period_seconds : ?Nat64;
    };
    public type NeuronsFundParticipationConstraints = {
        coefficient_intervals : [LinearScalingCoefficient];
        max_neurons_fund_participation_icp_e8s : ?Nat64;
        min_direct_participation_threshold_icp_e8s : ?Nat64;
        ideal_matched_participation_function : ?IdealMatchedParticipationFunction;
    };
    public type Ok = { sections : [MetadataSection] };
    public type PrettySnsVersion = {
        archive_wasm_hash : Text;
        root_wasm_hash : Text;
        swap_wasm_hash : Text;
        ledger_wasm_hash : Text;
        governance_wasm_hash : Text;
        index_wasm_hash : Text;
    };
    public type Result = { #Error : SnsWasmError; #Hash : Blob };
    public type Result_1 = { #Ok : Ok; #Error : SnsWasmError };
    public type SnsCanisterIds = {
        root : ?Principal;
        swap : ?Principal;
        ledger : ?Principal;
        index : ?Principal;
        governance : ?Principal;
    };
    public type SnsInitPayload = {
        url : ?Text;
        max_dissolve_delay_seconds : ?Nat64;
        max_dissolve_delay_bonus_percentage : ?Nat64;
        nns_proposal_id : ?Nat64;
        neurons_fund_participation : ?Bool;
        min_participant_icp_e8s : ?Nat64;
        neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters;
        fallback_controller_principal_ids : [Text];
        token_symbol : ?Text;
        final_reward_rate_basis_points : ?Nat64;
        max_icp_e8s : ?Nat64;
        neuron_minimum_stake_e8s : ?Nat64;
        confirmation_text : ?Text;
        logo : ?Text;
        name : ?Text;
        swap_start_timestamp_seconds : ?Nat64;
        swap_due_timestamp_seconds : ?Nat64;
        initial_voting_period_seconds : ?Nat64;
        neuron_minimum_dissolve_delay_to_vote_seconds : ?Nat64;
        description : ?Text;
        max_neuron_age_seconds_for_age_bonus : ?Nat64;
        min_participants : ?Nat64;
        initial_reward_rate_basis_points : ?Nat64;
        wait_for_quiet_deadline_increase_seconds : ?Nat64;
        transaction_fee_e8s : ?Nat64;
        dapp_canisters : ?DappCanisters;
        neurons_fund_participation_constraints : ?NeuronsFundParticipationConstraints;
        max_age_bonus_percentage : ?Nat64;
        initial_token_distribution : ?InitialTokenDistribution;
        reward_rate_transition_duration_seconds : ?Nat64;
        token_logo : ?Text;
        token_name : ?Text;
        max_participant_icp_e8s : ?Nat64;
        min_direct_participation_icp_e8s : ?Nat64;
        proposal_reject_cost_e8s : ?Nat64;
        restricted_countries : ?Countries;
        min_icp_e8s : ?Nat64;
        max_direct_participation_icp_e8s : ?Nat64;
    };
    public type SnsUpgrade = {
        next_version : ?SnsVersion;
        current_version : ?SnsVersion;
    };
    public type SnsVersion = {
        archive_wasm_hash : Blob;
        root_wasm_hash : Blob;
        swap_wasm_hash : Blob;
        ledger_wasm_hash : Blob;
        governance_wasm_hash : Blob;
        index_wasm_hash : Blob;
    };
    public type SnsWasm = {
        wasm : Blob;
        proposal_id : ?Nat64;
        canister_type : Int32;
    };
    public type SnsWasmCanisterInitPayload = {
        allowed_principals : [Principal];
        access_controls_enabled : Bool;
        sns_subnet_ids : [Principal];
    };
    public type SnsWasmError = { message : Text };
    public type SwapDistribution = {
        total_e8s : Nat64;
        initial_swap_amount_e8s : Nat64;
    };
    public type TreasuryDistribution = { total_e8s : Nat64 };
    public type UpdateAllowedPrincipalsRequest = {
        added_principals : [Principal];
        removed_principals : [Principal];
    };
    public type UpdateAllowedPrincipalsResponse = {
        update_allowed_principals_result : ?UpdateAllowedPrincipalsResult;
    };
    public type UpdateAllowedPrincipalsResult = {
        #Error : SnsWasmError;
        #AllowedPrincipals : GetAllowedPrincipalsResponse;
    };
    public type UpdateSnsSubnetListRequest = {
        sns_subnet_ids_to_add : [Principal];
        sns_subnet_ids_to_remove : [Principal];
    };
    public type UpdateSnsSubnetListResponse = { error : ?SnsWasmError };
    public type Self = actor {
        add_wasm : shared AddWasmRequest -> async AddWasmResponse;
        deploy_new_sns : shared DeployNewSnsRequest -> async DeployNewSnsResponse;
        get_allowed_principals : shared query {} -> async GetAllowedPrincipalsResponse;
        get_deployed_sns_by_proposal_id : shared query GetDeployedSnsByProposalIdRequest -> async GetDeployedSnsByProposalIdResponse;
        get_latest_sns_version_pretty : shared query Null -> async [(Text, Text)];
        get_next_sns_version : shared query GetNextSnsVersionRequest -> async GetNextSnsVersionResponse;
        get_proposal_id_that_added_wasm : shared query GetProposalIdThatAddedWasmRequest -> async GetProposalIdThatAddedWasmResponse;
        get_sns_subnet_ids : shared query {} -> async GetSnsSubnetIdsResponse;
        get_wasm : shared query GetWasmRequest -> async GetWasmResponse;
        get_wasm_metadata : shared query GetWasmMetadataRequest -> async GetWasmMetadataResponse;
        insert_upgrade_path_entries : shared InsertUpgradePathEntriesRequest -> async InsertUpgradePathEntriesResponse;
        list_deployed_snses : shared query {} -> async ListDeployedSnsesResponse;
        list_upgrade_steps : shared query ListUpgradeStepsRequest -> async ListUpgradeStepsResponse;
        update_allowed_principals : shared UpdateAllowedPrincipalsRequest -> async UpdateAllowedPrincipalsResponse;
        update_sns_subnet_list : shared UpdateSnsSubnetListRequest -> async UpdateSnsSubnetListResponse;
    };
};
