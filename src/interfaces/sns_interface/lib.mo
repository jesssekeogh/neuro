module {
  public type Account = { owner : ?Principal; subaccount : ?Subaccount };
  public type Action = {
    #ManageNervousSystemParameters : NervousSystemParameters;
    #AddGenericNervousSystemFunction : NervousSystemFunction;
    #ManageDappCanisterSettings : ManageDappCanisterSettings;
    #RemoveGenericNervousSystemFunction : Nat64;
    #SetTopicsForCustomProposals : SetTopicsForCustomProposals;
    #UpgradeSnsToNextVersion : {};
    #RegisterDappCanisters : RegisterDappCanisters;
    #TransferSnsTreasuryFunds : TransferSnsTreasuryFunds;
    #UpgradeSnsControlledCanister : UpgradeSnsControlledCanister;
    #DeregisterDappCanisters : DeregisterDappCanisters;
    #MintSnsTokens : MintSnsTokens;
    #AdvanceSnsTargetVersion : AdvanceSnsTargetVersion;
    #Unspecified : {};
    #ManageSnsMetadata : ManageSnsMetadata;
    #ExecuteGenericNervousSystemFunction : ExecuteGenericNervousSystemFunction;
    #ManageLedgerParameters : ManageLedgerParameters;
    #Motion : Motion;
  };
  public type ActionAuxiliary = {
    #TransferSnsTreasuryFunds : MintSnsTokensActionAuxiliary;
    #MintSnsTokens : MintSnsTokensActionAuxiliary;
    #AdvanceSnsTargetVersion : AdvanceSnsTargetVersionActionAuxiliary;
  };
  public type AddNeuronPermissions = {
    permissions_to_add : ?NeuronPermissionList;
    principal_id : ?Principal;
  };
  public type AdvanceSnsTargetVersion = { new_target : ?SnsVersion };
  public type AdvanceSnsTargetVersionActionAuxiliary = {
    target_version : ?SnsVersion;
  };
  public type Amount = { e8s : Nat64 };
  public type Ballot = {
    vote : Int32;
    cast_timestamp_seconds : Nat64;
    voting_power : Nat64;
  };
  public type By = { #MemoAndController : MemoAndController; #NeuronId : {} };
  public type CachedUpgradeSteps = {
    upgrade_steps : ?Versions;
    response_timestamp_seconds : ?Nat64;
    requested_timestamp_seconds : ?Nat64;
  };
  public type CanisterStatusResultV2 = {
    status : CanisterStatusType;
    memory_size : Nat;
    cycles : Nat;
    settings : DefiniteCanisterSettingsArgs;
    query_stats : ?QueryStats;
    idle_cycles_burned_per_day : Nat;
    module_hash : ?Blob;
  };
  public type CanisterStatusType = { #stopped; #stopping; #running };
  public type ChangeAutoStakeMaturity = {
    requested_setting_for_auto_stake_maturity : Bool;
  };
  public type ChunkedCanisterWasm = {
    wasm_module_hash : Blob;
    chunk_hashes_list : [Blob];
    store_canister_id : ?Principal;
  };
  public type ClaimOrRefresh = { by : ?By };
  public type ClaimOrRefreshResponse = { refreshed_neuron_id : ?NeuronId };
  public type ClaimSwapNeuronsRequest = { neuron_recipes : ?NeuronRecipes };
  public type ClaimSwapNeuronsResponse = {
    claim_swap_neurons_result : ?ClaimSwapNeuronsResult;
  };
  public type ClaimSwapNeuronsResult = {
    #Ok : ClaimedSwapNeurons;
    #Err : Int32;
  };
  public type ClaimedSwapNeurons = { swap_neurons : [SwapNeuron] };
  public type Command = {
    #Split : Split;
    #Follow : Follow;
    #DisburseMaturity : DisburseMaturity;
    #ClaimOrRefresh : ClaimOrRefresh;
    #Configure : Configure;
    #RegisterVote : RegisterVote;
    #SetFollowing : SetFollowing;
    #MakeProposal : Proposal;
    #StakeMaturity : StakeMaturity;
    #RemoveNeuronPermissions : RemoveNeuronPermissions;
    #AddNeuronPermissions : AddNeuronPermissions;
    #MergeMaturity : MergeMaturity;
    #Disburse : Disburse;
  };
  public type Command_1 = {
    #Error : GovernanceError;
    #Split : SplitResponse;
    #Follow : {};
    #DisburseMaturity : DisburseMaturityResponse;
    #ClaimOrRefresh : ClaimOrRefreshResponse;
    #Configure : {};
    #RegisterVote : {};
    #SetFollowing : {};
    #MakeProposal : GetProposal;
    #RemoveNeuronPermission : {};
    #StakeMaturity : StakeMaturityResponse;
    #MergeMaturity : MergeMaturityResponse;
    #Disburse : DisburseResponse;
    #AddNeuronPermission : {};
  };
  public type Command_2 = {
    #Split : Split;
    #Follow : Follow;
    #DisburseMaturity : DisburseMaturity;
    #Configure : Configure;
    #RegisterVote : RegisterVote;
    #SetFollowing : SetFollowing;
    #SyncCommand : {};
    #MakeProposal : Proposal;
    #FinalizeDisburseMaturity : FinalizeDisburseMaturity;
    #ClaimOrRefreshNeuron : ClaimOrRefresh;
    #RemoveNeuronPermissions : RemoveNeuronPermissions;
    #AddNeuronPermissions : AddNeuronPermissions;
    #MergeMaturity : MergeMaturity;
    #Disburse : Disburse;
  };
  public type Configure = { operation : ?Operation };
  public type Decimal = { human_readable : ?Text };
  public type DefaultFollowees = { followees : [(Nat64, Followees)] };
  public type DefiniteCanisterSettingsArgs = {
    freezing_threshold : Nat;
    wasm_memory_threshold : ?Nat;
    controllers : [Principal];
    wasm_memory_limit : ?Nat;
    memory_allocation : Nat;
    compute_allocation : Nat;
  };
  public type DeregisterDappCanisters = {
    canister_ids : [Principal];
    new_controllers : [Principal];
  };
  public type Disburse = { to_account : ?Account; amount : ?Amount };
  public type DisburseMaturity = {
    to_account : ?Account;
    percentage_to_disburse : Nat32;
  };
  public type DisburseMaturityInProgress = {
    timestamp_of_disbursement_seconds : Nat64;
    amount_e8s : Nat64;
    account_to_disburse_to : ?Account;
    finalize_disbursement_timestamp_seconds : ?Nat64;
  };
  public type DisburseMaturityResponse = {
    amount_disbursed_e8s : Nat64;
    amount_deducted_e8s : ?Nat64;
  };
  public type DisburseResponse = { transfer_block_height : Nat64 };
  public type DissolveState = {
    #DissolveDelaySeconds : Nat64;
    #WhenDissolvedTimestampSeconds : Nat64;
  };
  public type ExecuteGenericNervousSystemFunction = {
    function_id : Nat64;
    payload : Blob;
  };
  public type FinalizeDisburseMaturity = {
    amount_to_be_disbursed_e8s : Nat64;
    to_account : ?Account;
  };
  public type Follow = { function_id : Nat64; followees : [NeuronId] };
  public type Followee = { alias : ?Text; neuron_id : ?NeuronId };
  public type Followees = { followees : [NeuronId] };
  public type FolloweesForTopic = { topic : ?Topic; followees : [Followee] };
  public type FunctionType = {
    #NativeNervousSystemFunction : {};
    #GenericNervousSystemFunction : GenericNervousSystemFunction;
  };
  public type GenericNervousSystemFunction = {
    topic : ?Topic;
    validator_canister_id : ?Principal;
    target_canister_id : ?Principal;
    validator_method_name : ?Text;
    target_method_name : ?Text;
  };
  public type GetMaturityModulationResponse = {
    maturity_modulation : ?MaturityModulation;
  };
  public type GetMetadataResponse = {
    url : ?Text;
    logo : ?Text;
    name : ?Text;
    description : ?Text;
  };
  public type GetMetricsRequest = { time_window_seconds : ?Nat64 };
  public type GetMetricsResponse = { get_metrics_result : ?GetMetricsResult };
  public type GetMetricsResult = { #Ok : Metrics; #Err : GovernanceError };
  public type GetModeResponse = { mode : ?Int32 };
  public type GetNeuron = { neuron_id : ?NeuronId };
  public type GetNeuronResponse = { result : ?Result };
  public type GetProposal = { proposal_id : ?ProposalId };
  public type GetProposalResponse = { result : ?Result_1 };
  public type GetRunningSnsVersionResponse = {
    deployed_version : ?Version;
    pending_version : ?{
      mark_failed_at_seconds : Nat64;
      checking_upgrade_lock : Nat64;
      proposal_id : Nat64;
      target_version : ?Version;
    };
  };
  public type GetSnsInitializationParametersResponse = {
    sns_initialization_parameters : Text;
  };
  public type GetTimersResponse = { timers : ?Timers };
  public type GetUpgradeJournalRequest = { offset : ?Nat64; limit : ?Nat64 };
  public type GetUpgradeJournalResponse = {
    upgrade_journal : ?UpgradeJournal;
    upgrade_steps : ?Versions;
    response_timestamp_seconds : ?Nat64;
    deployed_version : ?Version;
    target_version : ?Version;
    upgrade_journal_entry_count : ?Nat64;
  };
  public type Governance = {
    root_canister_id : ?Principal;
    timers : ?Timers;
    cached_upgrade_steps : ?CachedUpgradeSteps;
    id_to_nervous_system_functions : [(Nat64, NervousSystemFunction)];
    metrics : ?GovernanceCachedMetrics;
    maturity_modulation : ?MaturityModulation;
    upgrade_journal : ?UpgradeJournal;
    mode : Int32;
    parameters : ?NervousSystemParameters;
    is_finalizing_disburse_maturity : ?Bool;
    deployed_version : ?Version;
    sns_initialization_parameters : Text;
    latest_reward_event : ?RewardEvent;
    pending_version : ?PendingVersion;
    swap_canister_id : ?Principal;
    ledger_canister_id : ?Principal;
    proposals : [(Nat64, ProposalData)];
    in_flight_commands : [(Text, NeuronInFlightCommand)];
    sns_metadata : ?ManageSnsMetadata;
    neurons : [(Text, Neuron)];
    target_version : ?Version;
    genesis_timestamp_seconds : Nat64;
  };
  public type GovernanceCachedMetrics = {
    not_dissolving_neurons_e8s_buckets : [(Nat64, Float)];
    garbage_collectable_neurons_count : Nat64;
    neurons_with_invalid_stake_count : Nat64;
    not_dissolving_neurons_count_buckets : [(Nat64, Nat64)];
    neurons_with_less_than_6_months_dissolve_delay_count : Nat64;
    dissolved_neurons_count : Nat64;
    total_staked_e8s : Nat64;
    total_supply_governance_tokens : Nat64;
    not_dissolving_neurons_count : Nat64;
    dissolved_neurons_e8s : Nat64;
    neurons_with_less_than_6_months_dissolve_delay_e8s : Nat64;
    dissolving_neurons_count_buckets : [(Nat64, Nat64)];
    dissolving_neurons_count : Nat64;
    dissolving_neurons_e8s_buckets : [(Nat64, Float)];
    timestamp_seconds : Nat64;
  };
  public type GovernanceError = { error_message : Text; error_type : Int32 };
  public type IncreaseDissolveDelay = {
    additional_dissolve_delay_seconds : Nat32;
  };
  public type ListNervousSystemFunctionsResponse = {
    reserved_ids : [Nat64];
    functions : [NervousSystemFunction];
  };
  public type ListNeurons = {
    of_principal : ?Principal;
    limit : Nat32;
    start_page_at : ?NeuronId;
  };
  public type ListNeuronsResponse = { neurons : [Neuron] };
  public type ListProposals = {
    include_reward_status : [Int32];
    before_proposal : ?ProposalId;
    limit : Nat32;
    exclude_type : [Nat64];
    include_topics : ?[TopicSelector];
    include_status : [Int32];
  };
  public type ListProposalsResponse = {
    include_ballots_by_caller : ?Bool;
    proposals : [ProposalData];
    include_topic_filtering : ?Bool;
  };
  public type ListTopicsRequest = {};
  public type ListTopicsResponse = {
    uncategorized_functions : ?[NervousSystemFunction];
    topics : ?[TopicInfo];
  };
  public type ManageDappCanisterSettings = {
    freezing_threshold : ?Nat64;
    wasm_memory_threshold : ?Nat64;
    canister_ids : [Principal];
    reserved_cycles_limit : ?Nat64;
    log_visibility : ?Int32;
    wasm_memory_limit : ?Nat64;
    memory_allocation : ?Nat64;
    compute_allocation : ?Nat64;
  };
  public type ManageLedgerParameters = {
    token_symbol : ?Text;
    transfer_fee : ?Nat64;
    token_logo : ?Text;
    token_name : ?Text;
  };
  public type ManageNeuron = { subaccount : Blob; command : ?Command };
  public type ManageNeuronResponse = { command : ?Command_1 };
  public type ManageSnsMetadata = {
    url : ?Text;
    logo : ?Text;
    name : ?Text;
    description : ?Text;
  };
  public type MaturityModulation = {
    current_basis_points : ?Int32;
    updated_at_timestamp_seconds : ?Nat64;
  };
  public type MemoAndController = { controller : ?Principal; memo : Nat64 };
  public type MergeMaturity = { percentage_to_merge : Nat32 };
  public type MergeMaturityResponse = {
    merged_maturity_e8s : Nat64;
    new_stake_e8s : Nat64;
  };
  public type Metrics = {
    last_ledger_block_timestamp : ?Nat64;
    num_recently_submitted_proposals : ?Nat64;
  };
  public type MintSnsTokens = {
    to_principal : ?Principal;
    to_subaccount : ?Subaccount;
    memo : ?Nat64;
    amount_e8s : ?Nat64;
  };
  public type MintSnsTokensActionAuxiliary = { valuation : ?Valuation };
  public type Motion = { motion_text : Text };
  public type NervousSystemFunction = {
    id : Nat64;
    name : Text;
    description : ?Text;
    function_type : ?FunctionType;
  };
  public type NervousSystemParameters = {
    default_followees : ?DefaultFollowees;
    max_dissolve_delay_seconds : ?Nat64;
    max_dissolve_delay_bonus_percentage : ?Nat64;
    max_followees_per_function : ?Nat64;
    automatically_advance_target_version : ?Bool;
    neuron_claimer_permissions : ?NeuronPermissionList;
    neuron_minimum_stake_e8s : ?Nat64;
    max_neuron_age_for_age_bonus : ?Nat64;
    initial_voting_period_seconds : ?Nat64;
    neuron_minimum_dissolve_delay_to_vote_seconds : ?Nat64;
    reject_cost_e8s : ?Nat64;
    max_proposals_to_keep_per_action : ?Nat32;
    wait_for_quiet_deadline_increase_seconds : ?Nat64;
    max_number_of_neurons : ?Nat64;
    transaction_fee_e8s : ?Nat64;
    max_number_of_proposals_with_ballots : ?Nat64;
    max_age_bonus_percentage : ?Nat64;
    neuron_grantable_permissions : ?NeuronPermissionList;
    voting_rewards_parameters : ?VotingRewardsParameters;
    maturity_modulation_disabled : ?Bool;
    max_number_of_principals_per_neuron : ?Nat64;
  };
  public type Neuron = {
    id : ?NeuronId;
    staked_maturity_e8s_equivalent : ?Nat64;
    permissions : [NeuronPermission];
    maturity_e8s_equivalent : Nat64;
    cached_neuron_stake_e8s : Nat64;
    created_timestamp_seconds : Nat64;
    topic_followees : ?{ topic_id_to_followees : [(Int32, FolloweesForTopic)] };
    source_nns_neuron_id : ?Nat64;
    auto_stake_maturity : ?Bool;
    aging_since_timestamp_seconds : Nat64;
    dissolve_state : ?DissolveState;
    voting_power_percentage_multiplier : Nat64;
    vesting_period_seconds : ?Nat64;
    disburse_maturity_in_progress : [DisburseMaturityInProgress];
    followees : [(Nat64, Followees)];
    neuron_fees_e8s : Nat64;
  };
  public type NeuronId = { id : Blob };
  public type NeuronIds = { neuron_ids : [NeuronId] };
  public type NeuronInFlightCommand = {
    command : ?Command_2;
    timestamp : Nat64;
  };
  public type NeuronPermission = {
    principal : ?Principal;
    permission_type : [Int32];
  };
  public type NeuronPermissionList = { permissions : [Int32] };
  public type NeuronRecipe = {
    controller : ?Principal;
    dissolve_delay_seconds : ?Nat64;
    participant : ?Participant;
    stake_e8s : ?Nat64;
    followees : ?NeuronIds;
    neuron_id : ?NeuronId;
  };
  public type NeuronRecipes = { neuron_recipes : [NeuronRecipe] };
  public type NeuronsFund = {
    nns_neuron_hotkeys : ?Principals;
    nns_neuron_controller : ?Principal;
    nns_neuron_id : ?Nat64;
  };
  public type Operation = {
    #ChangeAutoStakeMaturity : ChangeAutoStakeMaturity;
    #StopDissolving : {};
    #StartDissolving : {};
    #IncreaseDissolveDelay : IncreaseDissolveDelay;
    #SetDissolveTimestamp : SetDissolveTimestamp;
  };
  public type Participant = { #NeuronsFund : NeuronsFund; #Direct : {} };
  public type PendingVersion = {
    mark_failed_at_seconds : Nat64;
    checking_upgrade_lock : Nat64;
    proposal_id : ?Nat64;
    target_version : ?Version;
  };
  public type Percentage = { basis_points : ?Nat64 };
  public type Principals = { principals : [Principal] };
  public type Proposal = {
    url : Text;
    title : Text;
    action : ?Action;
    summary : Text;
  };
  public type ProposalData = {
    id : ?ProposalId;
    payload_text_rendering : ?Text;
    topic : ?Topic;
    action : Nat64;
    failure_reason : ?GovernanceError;
    action_auxiliary : ?ActionAuxiliary;
    ballots : [(Text, Ballot)];
    minimum_yes_proportion_of_total : ?Percentage;
    reward_event_round : Nat64;
    failed_timestamp_seconds : Nat64;
    reward_event_end_timestamp_seconds : ?Nat64;
    proposal_creation_timestamp_seconds : Nat64;
    initial_voting_period_seconds : Nat64;
    reject_cost_e8s : Nat64;
    latest_tally : ?Tally;
    wait_for_quiet_deadline_increase_seconds : Nat64;
    decided_timestamp_seconds : Nat64;
    proposal : ?Proposal;
    proposer : ?NeuronId;
    wait_for_quiet_state : ?WaitForQuietState;
    minimum_yes_proportion_of_exercised : ?Percentage;
    is_eligible_for_rewards : Bool;
    executed_timestamp_seconds : Nat64;
  };
  public type ProposalId = { id : Nat64 };
  public type QueryStats = {
    response_payload_bytes_total : ?Nat;
    num_instructions_total : ?Nat;
    num_calls_total : ?Nat;
    request_payload_bytes_total : ?Nat;
  };
  public type RegisterDappCanisters = { canister_ids : [Principal] };
  public type RegisterVote = { vote : Int32; proposal : ?ProposalId };
  public type RemoveNeuronPermissions = {
    permissions_to_remove : ?NeuronPermissionList;
    principal_id : ?Principal;
  };
  public type Result = { #Error : GovernanceError; #Neuron : Neuron };
  public type Result_1 = { #Error : GovernanceError; #Proposal : ProposalData };
  public type RewardEvent = {
    rounds_since_last_distribution : ?Nat64;
    actual_timestamp_seconds : Nat64;
    end_timestamp_seconds : ?Nat64;
    total_available_e8s_equivalent : ?Nat64;
    distributed_e8s_equivalent : Nat64;
    round : Nat64;
    settled_proposals : [ProposalId];
  };
  public type SetDissolveTimestamp = { dissolve_timestamp_seconds : Nat64 };
  public type SetFollowing = { topic_following : [FolloweesForTopic] };
  public type SetMode = { mode : Int32 };
  public type SetTopicsForCustomProposals = {
    custom_function_id_to_topic : [(Nat64, Topic)];
  };
  public type SnsVersion = {
    archive_wasm_hash : ?Blob;
    root_wasm_hash : ?Blob;
    swap_wasm_hash : ?Blob;
    ledger_wasm_hash : ?Blob;
    governance_wasm_hash : ?Blob;
    index_wasm_hash : ?Blob;
  };
  public type Split = { memo : Nat64; amount_e8s : Nat64 };
  public type SplitResponse = { created_neuron_id : ?NeuronId };
  public type StakeMaturity = { percentage_to_stake : ?Nat32 };
  public type StakeMaturityResponse = {
    maturity_e8s : Nat64;
    staked_maturity_e8s : Nat64;
  };
  public type Subaccount = { subaccount : Blob };
  public type SwapNeuron = { id : ?NeuronId; status : Int32 };
  public type Tally = {
    no : Nat64;
    yes : Nat64;
    total : Nat64;
    timestamp_seconds : Nat64;
  };
  public type TargetVersionReset = {
    human_readable : ?Text;
    old_target_version : ?Version;
    new_target_version : ?Version;
  };
  public type TargetVersionSet = {
    old_target_version : ?Version;
    new_target_version : ?Version;
    is_advanced_automatically : ?Bool;
  };
  public type Timers = {
    last_spawned_timestamp_seconds : ?Nat64;
    last_reset_timestamp_seconds : ?Nat64;
    requires_periodic_tasks : ?Bool;
  };
  public type Tokens = { e8s : ?Nat64 };
  public type Topic = {
    #DappCanisterManagement;
    #DaoCommunitySettings;
    #ApplicationBusinessLogic;
    #CriticalDappOperations;
    #TreasuryAssetManagement;
    #Governance;
    #SnsFrameworkManagement;
  };
  public type TopicInfo = {
    native_functions : ?[NervousSystemFunction];
    topic : ?Topic;
    is_critical : ?Bool;
    name : ?Text;
    description : ?Text;
    custom_functions : ?[NervousSystemFunction];
  };
  public type TopicSelector = { topic : ?Topic };
  public type TransferSnsTreasuryFunds = {
    from_treasury : Int32;
    to_principal : ?Principal;
    to_subaccount : ?Subaccount;
    memo : ?Nat64;
    amount_e8s : Nat64;
  };
  public type UpgradeInProgress = {
    mark_failed_at_seconds : Nat64;
    checking_upgrade_lock : Nat64;
    proposal_id : ?Nat64;
    target_version : ?Version;
  };
  public type UpgradeJournal = { entries : [UpgradeJournalEntry] };
  public type UpgradeJournalEntry = {
    event : ?{
      #TargetVersionSet : TargetVersionSet;
      #UpgradeStepsReset : UpgradeStepsReset;
      #UpgradeOutcome : UpgradeOutcome;
      #UpgradeStarted : UpgradeStarted;
      #UpgradeStepsRefreshed : UpgradeStepsRefreshed;
      #TargetVersionReset : TargetVersionReset;
    };
    timestamp_seconds : ?Nat64;
  };
  public type UpgradeOutcome = {
    status : ?{
      #Success : {};
      #Timeout : {};
      #ExternalFailure : {};
      #InvalidState : { version : ?Version };
    };
    human_readable : ?Text;
  };
  public type UpgradeSnsControlledCanister = {
    new_canister_wasm : Blob;
    mode : ?Int32;
    canister_id : ?Principal;
    chunked_canister_wasm : ?ChunkedCanisterWasm;
    canister_upgrade_arg : ?Blob;
  };
  public type UpgradeStarted = {
    current_version : ?Version;
    expected_version : ?Version;
    reason : ?{
      #UpgradeSnsToNextVersionProposal : ProposalId;
      #BehindTargetVersion : {};
    };
  };
  public type UpgradeStepsRefreshed = { upgrade_steps : ?Versions };
  public type UpgradeStepsReset = {
    human_readable : ?Text;
    upgrade_steps : ?Versions;
  };
  public type Valuation = {
    token : ?Int32;
    account : ?Account;
    valuation_factors : ?ValuationFactors;
    timestamp_seconds : ?Nat64;
  };
  public type ValuationFactors = {
    xdrs_per_icp : ?Decimal;
    icps_per_token : ?Decimal;
    tokens : ?Tokens;
  };
  public type Version = {
    archive_wasm_hash : Blob;
    root_wasm_hash : Blob;
    swap_wasm_hash : Blob;
    ledger_wasm_hash : Blob;
    governance_wasm_hash : Blob;
    index_wasm_hash : Blob;
  };
  public type Versions = { versions : [Version] };
  public type VotingRewardsParameters = {
    final_reward_rate_basis_points : ?Nat64;
    initial_reward_rate_basis_points : ?Nat64;
    reward_rate_transition_duration_seconds : ?Nat64;
    round_duration_seconds : ?Nat64;
  };
  public type WaitForQuietState = {
    current_deadline_timestamp_seconds : Nat64;
  };
  public type Self = actor {
    claim_swap_neurons : shared ClaimSwapNeuronsRequest -> async ClaimSwapNeuronsResponse;
    fail_stuck_upgrade_in_progress : shared {} -> async {};
    get_build_metadata : shared query () -> async Text;
    get_latest_reward_event : shared query () -> async RewardEvent;
    get_maturity_modulation : shared {} -> async GetMaturityModulationResponse;
    get_metadata : shared query {} -> async GetMetadataResponse;
    get_metrics : shared composite query GetMetricsRequest -> async GetMetricsResponse;
    get_mode : shared query {} -> async GetModeResponse;
    get_nervous_system_parameters : shared query Null -> async NervousSystemParameters;
    get_neuron : shared query GetNeuron -> async GetNeuronResponse;
    get_proposal : shared query GetProposal -> async GetProposalResponse;
    get_root_canister_status : shared Null -> async CanisterStatusResultV2;
    get_running_sns_version : shared query {} -> async GetRunningSnsVersionResponse;
    get_sns_initialization_parameters : shared query {} -> async GetSnsInitializationParametersResponse;
    get_timers : shared query {} -> async GetTimersResponse;
    get_upgrade_journal : shared query GetUpgradeJournalRequest -> async GetUpgradeJournalResponse;
    list_nervous_system_functions : shared query () -> async ListNervousSystemFunctionsResponse;
    list_neurons : shared query ListNeurons -> async ListNeuronsResponse;
    list_proposals : shared query ListProposals -> async ListProposalsResponse;
    list_topics : shared query ListTopicsRequest -> async ListTopicsResponse;
    manage_neuron : shared ManageNeuron -> async ManageNeuronResponse;
    reset_timers : shared {} -> async {};
    set_mode : shared SetMode -> async {};
  }
}