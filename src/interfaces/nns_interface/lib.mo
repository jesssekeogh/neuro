module {
  public type Account = { owner : ?Principal; subaccount : ?Blob };
  public type AccountIdentifier = { hash : Blob };
  public type Action = {
    #RegisterKnownNeuron : KnownNeuron;
    #ManageNeuron : ManageNeuron;
    #UpdateCanisterSettings : UpdateCanisterSettings;
    #InstallCode : InstallCode;
    #StopOrStartCanister : StopOrStartCanister;
    #CreateServiceNervousSystem : CreateServiceNervousSystem;
    #ExecuteNnsFunction : ExecuteNnsFunction;
    #RewardNodeProvider : RewardNodeProvider;
    #OpenSnsTokenSwap : OpenSnsTokenSwap;
    #SetSnsTokenSwapOpenTimeWindow : SetSnsTokenSwapOpenTimeWindow;
    #SetDefaultFollowees : SetDefaultFollowees;
    #RewardNodeProviders : RewardNodeProviders;
    #ManageNetworkEconomics : NetworkEconomics;
    #ApproveGenesisKyc : Principals;
    #AddOrRemoveNodeProvider : AddOrRemoveNodeProvider;
    #Motion : Motion;
  };
  public type AddHotKey = { new_hot_key : ?Principal };
  public type AddOrRemoveNodeProvider = { change : ?Change };
  public type Amount = { e8s : Nat64 };
  public type ApproveGenesisKyc = { principals : [Principal] };
  public type Ballot = { vote : Int32; voting_power : Nat64 };
  public type BallotInfo = { vote : Int32; proposal_id : ?ProposalId };
  public type By = {
    #NeuronIdOrSubaccount : {};
    #MemoAndController : ClaimOrRefreshNeuronFromAccount;
    #Memo : Nat64;
  };
  public type Canister = { id : ?Principal };
  public type CanisterSettings = {
    freezing_threshold : ?Nat64;
    wasm_memory_threshold : ?Nat64;
    controllers : ?Controllers;
    log_visibility : ?Int32;
    wasm_memory_limit : ?Nat64;
    memory_allocation : ?Nat64;
    compute_allocation : ?Nat64;
  };
  public type CanisterStatusResultV2 = {
    status : ?Int32;
    freezing_threshold : ?Nat64;
    controllers : [Principal];
    memory_size : ?Nat64;
    cycles : ?Nat64;
    idle_cycles_burned_per_day : ?Nat64;
    module_hash : Blob;
  };
  public type CanisterSummary = {
    status : ?CanisterStatusResultV2;
    canister_id : ?Principal;
  };
  public type Change = { #ToRemove : NodeProvider; #ToAdd : NodeProvider };
  public type ChangeAutoStakeMaturity = {
    requested_setting_for_auto_stake_maturity : Bool;
  };
  public type ClaimOrRefresh = { by : ?By };
  public type ClaimOrRefreshNeuronFromAccount = {
    controller : ?Principal;
    memo : Nat64;
  };
  public type ClaimOrRefreshNeuronFromAccountResponse = { result : ?Result_1 };
  public type ClaimOrRefreshResponse = { refreshed_neuron_id : ?NeuronId };
  public type Command = {
    #Spawn : Spawn;
    #Split : Split;
    #Follow : Follow;
    #DisburseMaturity : DisburseMaturity;
    #RefreshVotingPower : RefreshVotingPower;
    #ClaimOrRefresh : ClaimOrRefresh;
    #Configure : Configure;
    #RegisterVote : RegisterVote;
    #Merge : Merge;
    #DisburseToNeuron : DisburseToNeuron;
    #MakeProposal : Proposal;
    #StakeMaturity : StakeMaturity;
    #MergeMaturity : MergeMaturity;
    #Disburse : Disburse;
  };
  public type Command_1 = {
    #Error : GovernanceError;
    #Spawn : SpawnResponse;
    #Split : SpawnResponse;
    #Follow : {};
    #DisburseMaturity : DisburseMaturityResponse;
    #RefreshVotingPower : RefreshVotingPowerResponse;
    #ClaimOrRefresh : ClaimOrRefreshResponse;
    #Configure : {};
    #RegisterVote : {};
    #Merge : MergeResponse;
    #DisburseToNeuron : SpawnResponse;
    #MakeProposal : MakeProposalResponse;
    #StakeMaturity : StakeMaturityResponse;
    #MergeMaturity : MergeMaturityResponse;
    #Disburse : DisburseResponse;
  };
  public type Command_2 = {
    #Spawn : NeuronId;
    #Split : Split;
    #Configure : Configure;
    #Merge : Merge;
    #DisburseToNeuron : DisburseToNeuron;
    #SyncCommand : {};
    #ClaimOrRefreshNeuron : ClaimOrRefresh;
    #MergeMaturity : MergeMaturity;
    #Disburse : Disburse;
  };
  public type Committed = {
    total_direct_contribution_icp_e8s : ?Nat64;
    total_neurons_fund_contribution_icp_e8s : ?Nat64;
    sns_governance_canister_id : ?Principal;
  };
  public type Committed_1 = {
    total_direct_participation_icp_e8s : ?Nat64;
    total_neurons_fund_participation_icp_e8s : ?Nat64;
    sns_governance_canister_id : ?Principal;
  };
  public type Configure = { operation : ?Operation };
  public type Controllers = { controllers : [Principal] };
  public type Countries = { iso_codes : [Text] };
  public type CreateServiceNervousSystem = {
    url : ?Text;
    governance_parameters : ?GovernanceParameters;
    fallback_controller_principal_ids : [Principal];
    logo : ?Image;
    name : ?Text;
    ledger_parameters : ?LedgerParameters;
    description : ?Text;
    dapp_canisters : [Canister];
    swap_parameters : ?SwapParameters;
    initial_token_distribution : ?InitialTokenDistribution;
  };
  public type DateRangeFilter = {
    start_timestamp_seconds : ?Nat64;
    end_timestamp_seconds : ?Nat64;
  };
  public type Decimal = { human_readable : ?Text };
  public type DerivedProposalInformation = {
    swap_background_information : ?SwapBackgroundInformation;
  };
  public type DeveloperDistribution = {
    developer_neurons : [NeuronDistribution];
  };
  public type Disburse = { to_account : ?AccountIdentifier; amount : ?Amount };
  public type DisburseMaturity = {
    to_account_identifier : ?AccountIdentifier;
    to_account : ?Account;
    percentage_to_disburse : Nat32;
  };
  public type DisburseMaturityResponse = { amount_disbursed_e8s : ?Nat64 };
  public type DisburseResponse = { transfer_block_height : Nat64 };
  public type DisburseToNeuron = {
    dissolve_delay_seconds : Nat64;
    kyc_verified : Bool;
    amount_e8s : Nat64;
    new_controller : ?Principal;
    nonce : Nat64;
  };
  public type DissolveState = {
    #DissolveDelaySeconds : Nat64;
    #WhenDissolvedTimestampSeconds : Nat64;
  };
  public type Duration = { seconds : ?Nat64 };
  public type ExecuteNnsFunction = { nns_function : Int32; payload : Blob };
  public type Follow = { topic : Int32; followees : [NeuronId] };
  public type Followees = { followees : [NeuronId] };
  public type GetNeuronsFundAuditInfoRequest = {
    nns_proposal_id : ?ProposalId;
  };
  public type GetNeuronsFundAuditInfoResponse = { result : ?Result_6 };
  public type GlobalTimeOfDay = { seconds_after_utc_midnight : ?Nat64 };
  public type Governance = {
    default_followees : [(Int32, Followees)];
    making_sns_proposal : ?MakingSnsProposal;
    most_recent_monthly_node_provider_rewards : ?MonthlyNodeProviderRewards;
    maturity_modulation_last_updated_at_timestamp_seconds : ?Nat64;
    wait_for_quiet_threshold_seconds : Nat64;
    metrics : ?GovernanceCachedMetrics;
    neuron_management_voting_period_seconds : ?Nat64;
    node_providers : [NodeProvider];
    cached_daily_maturity_modulation_basis_points : ?Int32;
    economics : ?NetworkEconomics;
    restore_aging_summary : ?RestoreAgingSummary;
    spawning_neurons : ?Bool;
    latest_reward_event : ?RewardEvent;
    to_claim_transfers : [NeuronStakeTransfer];
    short_voting_period_seconds : Nat64;
    proposals : [(Nat64, ProposalData)];
    xdr_conversion_rate : ?XdrConversionRate;
    in_flight_commands : [(Nat64, NeuronInFlightCommand)];
    neurons : [(Nat64, Neuron)];
    genesis_timestamp_seconds : Nat64;
  };
  public type GovernanceCachedMetrics = {
    total_maturity_e8s_equivalent : Nat64;
    not_dissolving_neurons_e8s_buckets : [(Nat64, Float)];
    dissolving_neurons_staked_maturity_e8s_equivalent_sum : Nat64;
    garbage_collectable_neurons_count : Nat64;
    dissolving_neurons_staked_maturity_e8s_equivalent_buckets : [
      (Nat64, Float)
    ];
    neurons_with_invalid_stake_count : Nat64;
    not_dissolving_neurons_count_buckets : [(Nat64, Nat64)];
    ect_neuron_count : Nat64;
    total_supply_icp : Nat64;
    neurons_with_less_than_6_months_dissolve_delay_count : Nat64;
    dissolved_neurons_count : Nat64;
    community_fund_total_maturity_e8s_equivalent : Nat64;
    total_staked_e8s_seed : Nat64;
    total_staked_maturity_e8s_equivalent_ect : Nat64;
    total_staked_e8s : Nat64;
    fully_lost_voting_power_neuron_subset_metrics : ?NeuronSubsetMetrics;
    not_dissolving_neurons_count : Nat64;
    total_locked_e8s : Nat64;
    neurons_fund_total_active_neurons : Nat64;
    total_voting_power_non_self_authenticating_controller : ?Nat64;
    total_staked_maturity_e8s_equivalent : Nat64;
    not_dissolving_neurons_e8s_buckets_ect : [(Nat64, Float)];
    declining_voting_power_neuron_subset_metrics : ?NeuronSubsetMetrics;
    total_staked_e8s_ect : Nat64;
    not_dissolving_neurons_staked_maturity_e8s_equivalent_sum : Nat64;
    dissolved_neurons_e8s : Nat64;
    total_staked_e8s_non_self_authenticating_controller : ?Nat64;
    dissolving_neurons_e8s_buckets_seed : [(Nat64, Float)];
    neurons_with_less_than_6_months_dissolve_delay_e8s : Nat64;
    not_dissolving_neurons_staked_maturity_e8s_equivalent_buckets : [
      (Nat64, Float)
    ];
    dissolving_neurons_count_buckets : [(Nat64, Nat64)];
    dissolving_neurons_e8s_buckets_ect : [(Nat64, Float)];
    non_self_authenticating_controller_neuron_subset_metrics : ?NeuronSubsetMetrics;
    dissolving_neurons_count : Nat64;
    dissolving_neurons_e8s_buckets : [(Nat64, Float)];
    total_staked_maturity_e8s_equivalent_seed : Nat64;
    community_fund_total_staked_e8s : Nat64;
    not_dissolving_neurons_e8s_buckets_seed : [(Nat64, Float)];
    public_neuron_subset_metrics : ?NeuronSubsetMetrics;
    timestamp_seconds : Nat64;
    seed_neuron_count : Nat64;
  };
  public type GovernanceError = { error_message : Text; error_type : Int32 };
  public type GovernanceParameters = {
    neuron_maximum_dissolve_delay_bonus : ?Percentage;
    neuron_maximum_age_for_age_bonus : ?Duration;
    neuron_maximum_dissolve_delay : ?Duration;
    neuron_minimum_dissolve_delay_to_vote : ?Duration;
    neuron_maximum_age_bonus : ?Percentage;
    neuron_minimum_stake : ?Tokens;
    proposal_wait_for_quiet_deadline_increase : ?Duration;
    proposal_initial_voting_period : ?Duration;
    proposal_rejection_fee : ?Tokens;
    voting_reward_parameters : ?VotingRewardParameters;
  };
  public type IdealMatchedParticipationFunction = {
    serialized_representation : ?Text;
  };
  public type Image = { base64_encoding : ?Text };
  public type IncreaseDissolveDelay = {
    additional_dissolve_delay_seconds : Nat32;
  };
  public type InitialTokenDistribution = {
    treasury_distribution : ?SwapDistribution;
    developer_distribution : ?DeveloperDistribution;
    swap_distribution : ?SwapDistribution;
  };
  public type InstallCode = {
    skip_stopping_before_installing : ?Bool;
    wasm_module_hash : ?Blob;
    canister_id : ?Principal;
    arg_hash : ?Blob;
    install_mode : ?Int32;
  };
  public type InstallCodeRequest = {
    arg : ?Blob;
    wasm_module : ?Blob;
    skip_stopping_before_installing : ?Bool;
    canister_id : ?Principal;
    install_mode : ?Int32;
  };
  public type KnownNeuron = {
    id : ?NeuronId;
    known_neuron_data : ?KnownNeuronData;
  };
  public type KnownNeuronData = { name : Text; description : ?Text };
  public type LedgerParameters = {
    transaction_fee : ?Tokens;
    token_symbol : ?Text;
    token_logo : ?Image;
    token_name : ?Text;
  };
  public type ListKnownNeuronsResponse = { known_neurons : [KnownNeuron] };
  public type ListNeurons = {
    page_size : ?Nat64;
    include_public_neurons_in_full_neurons : ?Bool;
    neuron_ids : [Nat64];
    page_number : ?Nat64;
    include_empty_neurons_readable_by_caller : ?Bool;
    neuron_subaccounts : ?[NeuronSubaccount];
    include_neurons_readable_by_caller : Bool;
  };
  public type ListNeuronsResponse = {
    neuron_infos : [(Nat64, NeuronInfo)];
    full_neurons : [Neuron];
    total_pages_available : ?Nat64;
  };
  public type ListNodeProviderRewardsRequest = {
    date_filter : ?DateRangeFilter;
  };
  public type ListNodeProviderRewardsResponse = {
    rewards : [MonthlyNodeProviderRewards];
  };
  public type ListNodeProvidersResponse = { node_providers : [NodeProvider] };
  public type ListProposalInfo = {
    include_reward_status : [Int32];
    omit_large_fields : ?Bool;
    before_proposal : ?ProposalId;
    limit : Nat32;
    exclude_topic : [Int32];
    include_all_manage_neuron_proposals : ?Bool;
    include_status : [Int32];
  };
  public type ListProposalInfoResponse = { proposal_info : [ProposalInfo] };
  public type MakeProposalRequest = {
    url : Text;
    title : ?Text;
    action : ?ProposalActionRequest;
    summary : Text;
  };
  public type MakeProposalResponse = {
    message : ?Text;
    proposal_id : ?ProposalId;
  };
  public type MakingSnsProposal = {
    proposal : ?Proposal;
    caller : ?Principal;
    proposer_id : ?NeuronId;
  };
  public type ManageNeuron = {
    id : ?NeuronId;
    command : ?Command;
    neuron_id_or_subaccount : ?NeuronIdOrSubaccount;
  };
  public type ManageNeuronCommandRequest = {
    #Spawn : Spawn;
    #Split : Split;
    #Follow : Follow;
    #DisburseMaturity : DisburseMaturity;
    #RefreshVotingPower : RefreshVotingPower;
    #ClaimOrRefresh : ClaimOrRefresh;
    #Configure : Configure;
    #RegisterVote : RegisterVote;
    #Merge : Merge;
    #DisburseToNeuron : DisburseToNeuron;
    #MakeProposal : MakeProposalRequest;
    #StakeMaturity : StakeMaturity;
    #MergeMaturity : MergeMaturity;
    #Disburse : Disburse;
  };
  public type ManageNeuronRequest = {
    id : ?NeuronId;
    command : ?ManageNeuronCommandRequest;
    neuron_id_or_subaccount : ?NeuronIdOrSubaccount;
  };
  public type ManageNeuronResponse = { command : ?Command_1 };
  public type MaturityDisbursement = {
    account_identifier_to_disburse_to : ?AccountIdentifier;
    timestamp_of_disbursement_seconds : ?Nat64;
    amount_e8s : ?Nat64;
    account_to_disburse_to : ?Account;
    finalize_disbursement_timestamp_seconds : ?Nat64;
  };
  public type Merge = { source_neuron_id : ?NeuronId };
  public type MergeMaturity = { percentage_to_merge : Nat32 };
  public type MergeMaturityResponse = {
    merged_maturity_e8s : Nat64;
    new_stake_e8s : Nat64;
  };
  public type MergeResponse = {
    target_neuron : ?Neuron;
    source_neuron : ?Neuron;
    target_neuron_info : ?NeuronInfo;
    source_neuron_info : ?NeuronInfo;
  };
  public type MonthlyNodeProviderRewards = {
    minimum_xdr_permyriad_per_icp : ?Nat64;
    registry_version : ?Nat64;
    node_providers : [NodeProvider];
    timestamp : Nat64;
    rewards : [RewardNodeProvider];
    xdr_conversion_rate : ?XdrConversionRate;
    maximum_node_provider_rewards_e8s : ?Nat64;
  };
  public type Motion = { motion_text : Text };
  public type NetworkEconomics = {
    neuron_minimum_stake_e8s : Nat64;
    voting_power_economics : ?VotingPowerEconomics;
    max_proposals_to_keep_per_topic : Nat32;
    neuron_management_fee_per_proposal_e8s : Nat64;
    reject_cost_e8s : Nat64;
    transaction_fee_e8s : Nat64;
    neuron_spawn_dissolve_delay_seconds : Nat64;
    minimum_icp_xdr_rate : Nat64;
    maximum_node_provider_rewards_e8s : Nat64;
    neurons_fund_economics : ?NeuronsFundEconomics;
  };
  public type Neuron = {
    id : ?NeuronId;
    staked_maturity_e8s_equivalent : ?Nat64;
    controller : ?Principal;
    recent_ballots : [BallotInfo];
    voting_power_refreshed_timestamp_seconds : ?Nat64;
    kyc_verified : Bool;
    potential_voting_power : ?Nat64;
    neuron_type : ?Int32;
    not_for_profit : Bool;
    maturity_e8s_equivalent : Nat64;
    deciding_voting_power : ?Nat64;
    cached_neuron_stake_e8s : Nat64;
    created_timestamp_seconds : Nat64;
    auto_stake_maturity : ?Bool;
    aging_since_timestamp_seconds : Nat64;
    hot_keys : [Principal];
    account : Blob;
    joined_community_fund_timestamp_seconds : ?Nat64;
    maturity_disbursements_in_progress : ?[MaturityDisbursement];
    dissolve_state : ?DissolveState;
    followees : [(Int32, Followees)];
    neuron_fees_e8s : Nat64;
    visibility : ?Int32;
    transfer : ?NeuronStakeTransfer;
    known_neuron_data : ?KnownNeuronData;
    spawn_at_timestamp_seconds : ?Nat64;
  };
  public type NeuronBasketConstructionParameters = {
    dissolve_delay_interval : ?Duration;
    count : ?Nat64;
  };
  public type NeuronBasketConstructionParameters_1 = {
    dissolve_delay_interval_seconds : Nat64;
    count : Nat64;
  };
  public type NeuronDistribution = {
    controller : ?Principal;
    dissolve_delay : ?Duration;
    memo : ?Nat64;
    vesting_period : ?Duration;
    stake : ?Tokens;
  };
  public type NeuronId = { id : Nat64 };
  public type NeuronIdOrSubaccount = {
    #Subaccount : Blob;
    #NeuronId : NeuronId;
  };
  public type NeuronInFlightCommand = {
    command : ?Command_2;
    timestamp : Nat64;
  };
  public type NeuronInfo = {
    dissolve_delay_seconds : Nat64;
    recent_ballots : [BallotInfo];
    voting_power_refreshed_timestamp_seconds : ?Nat64;
    potential_voting_power : ?Nat64;
    neuron_type : ?Int32;
    deciding_voting_power : ?Nat64;
    created_timestamp_seconds : Nat64;
    state : Int32;
    stake_e8s : Nat64;
    joined_community_fund_timestamp_seconds : ?Nat64;
    retrieved_at_timestamp_seconds : Nat64;
    visibility : ?Int32;
    known_neuron_data : ?KnownNeuronData;
    voting_power : Nat64;
    age_seconds : Nat64;
  };
  public type NeuronStakeTransfer = {
    to_subaccount : Blob;
    neuron_stake_e8s : Nat64;
    from : ?Principal;
    memo : Nat64;
    from_subaccount : Blob;
    transfer_timestamp : Nat64;
    block_height : Nat64;
  };
  public type NeuronSubaccount = { subaccount : Blob };
  public type NeuronSubsetMetrics = {
    total_maturity_e8s_equivalent : ?Nat64;
    maturity_e8s_equivalent_buckets : [(Nat64, Nat64)];
    voting_power_buckets : [(Nat64, Nat64)];
    total_staked_e8s : ?Nat64;
    count : ?Nat64;
    deciding_voting_power_buckets : [(Nat64, Nat64)];
    total_staked_maturity_e8s_equivalent : ?Nat64;
    total_potential_voting_power : ?Nat64;
    total_deciding_voting_power : ?Nat64;
    staked_maturity_e8s_equivalent_buckets : [(Nat64, Nat64)];
    staked_e8s_buckets : [(Nat64, Nat64)];
    total_voting_power : ?Nat64;
    potential_voting_power_buckets : [(Nat64, Nat64)];
    count_buckets : [(Nat64, Nat64)];
  };
  public type NeuronsFundAuditInfo = {
    final_neurons_fund_participation : ?NeuronsFundParticipation;
    initial_neurons_fund_participation : ?NeuronsFundParticipation;
    neurons_fund_refunds : ?NeuronsFundSnapshot;
  };
  public type NeuronsFundData = {
    final_neurons_fund_participation : ?NeuronsFundParticipation;
    initial_neurons_fund_participation : ?NeuronsFundParticipation;
    neurons_fund_refunds : ?NeuronsFundSnapshot;
  };
  public type NeuronsFundEconomics = {
    maximum_icp_xdr_rate : ?Percentage;
    neurons_fund_matched_funding_curve_coefficients : ?NeuronsFundMatchedFundingCurveCoefficients;
    max_theoretical_neurons_fund_participation_amount_xdr : ?Decimal;
    minimum_icp_xdr_rate : ?Percentage;
  };
  public type NeuronsFundMatchedFundingCurveCoefficients = {
    contribution_threshold_xdr : ?Decimal;
    one_third_participation_milestone_xdr : ?Decimal;
    full_participation_milestone_xdr : ?Decimal;
  };
  public type NeuronsFundNeuron = {
    controller : ?Principal;
    hotkeys : ?Principals;
    is_capped : ?Bool;
    nns_neuron_id : ?Nat64;
    amount_icp_e8s : ?Nat64;
  };
  public type NeuronsFundNeuronPortion = {
    controller : ?Principal;
    hotkeys : [Principal];
    is_capped : ?Bool;
    maturity_equivalent_icp_e8s : ?Nat64;
    nns_neuron_id : ?NeuronId;
    amount_icp_e8s : ?Nat64;
  };
  public type NeuronsFundParticipation = {
    total_maturity_equivalent_icp_e8s : ?Nat64;
    intended_neurons_fund_participation_icp_e8s : ?Nat64;
    direct_participation_icp_e8s : ?Nat64;
    swap_participation_limits : ?SwapParticipationLimits;
    max_neurons_fund_swap_participation_icp_e8s : ?Nat64;
    neurons_fund_reserves : ?NeuronsFundSnapshot;
    ideal_matched_participation_function : ?IdealMatchedParticipationFunction;
    allocated_neurons_fund_participation_icp_e8s : ?Nat64;
  };
  public type NeuronsFundSnapshot = {
    neurons_fund_neuron_portions : [NeuronsFundNeuronPortion];
  };
  public type NodeProvider = {
    id : ?Principal;
    reward_account : ?AccountIdentifier;
  };
  public type Ok = { neurons_fund_audit_info : ?NeuronsFundAuditInfo };
  public type Ok_1 = { neurons_fund_neuron_portions : [NeuronsFundNeuron] };
  public type OpenSnsTokenSwap = {
    community_fund_investment_e8s : ?Nat64;
    target_swap_canister_id : ?Principal;
    params : ?Params;
  };
  public type Operation = {
    #RemoveHotKey : RemoveHotKey;
    #AddHotKey : AddHotKey;
    #ChangeAutoStakeMaturity : ChangeAutoStakeMaturity;
    #StopDissolving : {};
    #StartDissolving : {};
    #IncreaseDissolveDelay : IncreaseDissolveDelay;
    #SetVisibility : SetVisibility;
    #JoinCommunityFund : {};
    #LeaveCommunityFund : {};
    #SetDissolveTimestamp : SetDissolveTimestamp;
  };
  public type Params = {
    min_participant_icp_e8s : Nat64;
    neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters_1;
    max_icp_e8s : Nat64;
    swap_due_timestamp_seconds : Nat64;
    min_participants : Nat32;
    sns_token_e8s : Nat64;
    sale_delay_seconds : ?Nat64;
    max_participant_icp_e8s : Nat64;
    min_direct_participation_icp_e8s : ?Nat64;
    min_icp_e8s : Nat64;
    max_direct_participation_icp_e8s : ?Nat64;
  };
  public type Percentage = { basis_points : ?Nat64 };
  public type Principals = { principals : [Principal] };
  public type Proposal = {
    url : Text;
    title : ?Text;
    action : ?Action;
    summary : Text;
  };
  public type ProposalActionRequest = {
    #RegisterKnownNeuron : KnownNeuron;
    #ManageNeuron : ManageNeuronRequest;
    #UpdateCanisterSettings : UpdateCanisterSettings;
    #InstallCode : InstallCodeRequest;
    #StopOrStartCanister : StopOrStartCanister;
    #CreateServiceNervousSystem : CreateServiceNervousSystem;
    #ExecuteNnsFunction : ExecuteNnsFunction;
    #RewardNodeProvider : RewardNodeProvider;
    #RewardNodeProviders : RewardNodeProviders;
    #ManageNetworkEconomics : NetworkEconomics;
    #ApproveGenesisKyc : Principals;
    #AddOrRemoveNodeProvider : AddOrRemoveNodeProvider;
    #Motion : Motion;
  };
  public type ProposalData = {
    id : ?ProposalId;
    topic : ?Int32;
    failure_reason : ?GovernanceError;
    ballots : [(Nat64, Ballot)];
    proposal_timestamp_seconds : Nat64;
    reward_event_round : Nat64;
    failed_timestamp_seconds : Nat64;
    neurons_fund_data : ?NeuronsFundData;
    reject_cost_e8s : Nat64;
    derived_proposal_information : ?DerivedProposalInformation;
    latest_tally : ?Tally;
    total_potential_voting_power : ?Nat64;
    sns_token_swap_lifecycle : ?Int32;
    decided_timestamp_seconds : Nat64;
    proposal : ?Proposal;
    proposer : ?NeuronId;
    wait_for_quiet_state : ?WaitForQuietState;
    executed_timestamp_seconds : Nat64;
    original_total_community_fund_maturity_e8s_equivalent : ?Nat64;
  };
  public type ProposalId = { id : Nat64 };
  public type ProposalInfo = {
    id : ?ProposalId;
    status : Int32;
    topic : Int32;
    failure_reason : ?GovernanceError;
    ballots : [(Nat64, Ballot)];
    proposal_timestamp_seconds : Nat64;
    reward_event_round : Nat64;
    deadline_timestamp_seconds : ?Nat64;
    failed_timestamp_seconds : Nat64;
    reject_cost_e8s : Nat64;
    derived_proposal_information : ?DerivedProposalInformation;
    latest_tally : ?Tally;
    total_potential_voting_power : ?Nat64;
    reward_status : Int32;
    decided_timestamp_seconds : Nat64;
    proposal : ?Proposal;
    proposer : ?NeuronId;
    executed_timestamp_seconds : Nat64;
  };
  public type RefreshVotingPower = {};
  public type RefreshVotingPowerResponse = {};
  public type RegisterVote = { vote : Int32; proposal : ?ProposalId };
  public type RemoveHotKey = { hot_key_to_remove : ?Principal };
  public type RestoreAgingNeuronGroup = {
    count : ?Nat64;
    previous_total_stake_e8s : ?Nat64;
    current_total_stake_e8s : ?Nat64;
    group_type : Int32;
  };
  public type RestoreAgingSummary = {
    groups : [RestoreAgingNeuronGroup];
    timestamp_seconds : ?Nat64;
  };
  public type Result = { #Ok; #Err : GovernanceError };
  public type Result_1 = { #Error : GovernanceError; #NeuronId : NeuronId };
  public type Result_10 = { #Ok : Ok_1; #Err : GovernanceError };
  public type Result_2 = { #Ok : Neuron; #Err : GovernanceError };
  public type Result_3 = {
    #Ok : GovernanceCachedMetrics;
    #Err : GovernanceError;
  };
  public type Result_4 = {
    #Ok : MonthlyNodeProviderRewards;
    #Err : GovernanceError;
  };
  public type Result_5 = { #Ok : NeuronInfo; #Err : GovernanceError };
  public type Result_6 = { #Ok : Ok; #Err : GovernanceError };
  public type Result_7 = { #Ok : NodeProvider; #Err : GovernanceError };
  public type Result_8 = { #Committed : Committed; #Aborted : {} };
  public type Result_9 = { #Committed : Committed_1; #Aborted : {} };
  public type RewardEvent = {
    rounds_since_last_distribution : ?Nat64;
    day_after_genesis : Nat64;
    actual_timestamp_seconds : Nat64;
    total_available_e8s_equivalent : Nat64;
    latest_round_available_e8s_equivalent : ?Nat64;
    distributed_e8s_equivalent : Nat64;
    settled_proposals : [ProposalId];
  };
  public type RewardMode = {
    #RewardToNeuron : RewardToNeuron;
    #RewardToAccount : RewardToAccount;
  };
  public type RewardNodeProvider = {
    node_provider : ?NodeProvider;
    reward_mode : ?RewardMode;
    amount_e8s : Nat64;
  };
  public type RewardNodeProviders = {
    use_registry_derived_rewards : ?Bool;
    rewards : [RewardNodeProvider];
  };
  public type RewardToAccount = { to_account : ?AccountIdentifier };
  public type RewardToNeuron = { dissolve_delay_seconds : Nat64 };
  public type SetDefaultFollowees = {
    default_followees : [(Int32, Followees)];
  };
  public type SetDissolveTimestamp = { dissolve_timestamp_seconds : Nat64 };
  public type SetOpenTimeWindowRequest = { open_time_window : ?TimeWindow };
  public type SetSnsTokenSwapOpenTimeWindow = {
    request : ?SetOpenTimeWindowRequest;
    swap_canister_id : ?Principal;
  };
  public type SetVisibility = { visibility : ?Int32 };
  public type SettleCommunityFundParticipation = {
    result : ?Result_8;
    open_sns_token_swap_proposal_id : ?Nat64;
  };
  public type SettleNeuronsFundParticipationRequest = {
    result : ?Result_9;
    nns_proposal_id : ?Nat64;
  };
  public type SettleNeuronsFundParticipationResponse = { result : ?Result_10 };
  public type Spawn = {
    percentage_to_spawn : ?Nat32;
    new_controller : ?Principal;
    nonce : ?Nat64;
  };
  public type SpawnResponse = { created_neuron_id : ?NeuronId };
  public type Split = { amount_e8s : Nat64 };
  public type StakeMaturity = { percentage_to_stake : ?Nat32 };
  public type StakeMaturityResponse = {
    maturity_e8s : Nat64;
    staked_maturity_e8s : Nat64;
  };
  public type StopOrStartCanister = {
    action : ?Int32;
    canister_id : ?Principal;
  };
  public type SwapBackgroundInformation = {
    ledger_index_canister_summary : ?CanisterSummary;
    fallback_controller_principal_ids : [Principal];
    ledger_archive_canister_summaries : [CanisterSummary];
    ledger_canister_summary : ?CanisterSummary;
    swap_canister_summary : ?CanisterSummary;
    governance_canister_summary : ?CanisterSummary;
    root_canister_summary : ?CanisterSummary;
    dapp_canister_summaries : [CanisterSummary];
  };
  public type SwapDistribution = { total : ?Tokens };
  public type SwapParameters = {
    minimum_participants : ?Nat64;
    neurons_fund_participation : ?Bool;
    duration : ?Duration;
    neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters;
    confirmation_text : ?Text;
    maximum_participant_icp : ?Tokens;
    minimum_icp : ?Tokens;
    minimum_direct_participation_icp : ?Tokens;
    minimum_participant_icp : ?Tokens;
    start_time : ?GlobalTimeOfDay;
    maximum_direct_participation_icp : ?Tokens;
    maximum_icp : ?Tokens;
    neurons_fund_investment_icp : ?Tokens;
    restricted_countries : ?Countries;
  };
  public type SwapParticipationLimits = {
    min_participant_icp_e8s : ?Nat64;
    max_participant_icp_e8s : ?Nat64;
    min_direct_participation_icp_e8s : ?Nat64;
    max_direct_participation_icp_e8s : ?Nat64;
  };
  public type Tally = {
    no : Nat64;
    yes : Nat64;
    total : Nat64;
    timestamp_seconds : Nat64;
  };
  public type TimeWindow = {
    start_timestamp_seconds : Nat64;
    end_timestamp_seconds : Nat64;
  };
  public type Tokens = { e8s : ?Nat64 };
  public type UpdateCanisterSettings = {
    canister_id : ?Principal;
    settings : ?CanisterSettings;
  };
  public type UpdateNodeProvider = { reward_account : ?AccountIdentifier };
  public type VotingPowerEconomics = {
    start_reducing_voting_power_after_seconds : ?Nat64;
    neuron_minimum_dissolve_delay_to_vote_seconds : ?Nat64;
    clear_following_after_seconds : ?Nat64;
  };
  public type VotingRewardParameters = {
    reward_rate_transition_duration : ?Duration;
    initial_reward_rate : ?Percentage;
    final_reward_rate : ?Percentage;
  };
  public type WaitForQuietState = {
    current_deadline_timestamp_seconds : Nat64;
  };
  public type XdrConversionRate = {
    xdr_permyriad_per_icp : ?Nat64;
    timestamp_seconds : ?Nat64;
  };
  public type Self = actor {
    claim_gtc_neurons : shared (Principal, [NeuronId]) -> async Result;
    claim_or_refresh_neuron_from_account : shared ClaimOrRefreshNeuronFromAccount -> async ClaimOrRefreshNeuronFromAccountResponse;
    get_build_metadata : shared query () -> async Text;
    get_full_neuron : shared query Nat64 -> async Result_2;
    get_full_neuron_by_id_or_subaccount : shared query NeuronIdOrSubaccount -> async Result_2;
    get_latest_reward_event : shared query () -> async RewardEvent;
    get_metrics : shared query () -> async Result_3;
    get_monthly_node_provider_rewards : shared () -> async Result_4;
    get_most_recent_monthly_node_provider_rewards : shared query () -> async ?MonthlyNodeProviderRewards;
    get_network_economics_parameters : shared query () -> async NetworkEconomics;
    get_neuron_ids : shared query () -> async [Nat64];
    get_neuron_info : shared query Nat64 -> async Result_5;
    get_neuron_info_by_id_or_subaccount : shared query NeuronIdOrSubaccount -> async Result_5;
    get_neurons_fund_audit_info : shared query GetNeuronsFundAuditInfoRequest -> async GetNeuronsFundAuditInfoResponse;
    get_node_provider_by_caller : shared query Null -> async Result_7;
    get_pending_proposals : shared query () -> async [ProposalInfo];
    get_proposal_info : shared query Nat64 -> async ?ProposalInfo;
    get_restore_aging_summary : shared query () -> async RestoreAgingSummary;
    list_known_neurons : shared query () -> async ListKnownNeuronsResponse;
    list_neurons : shared query ListNeurons -> async ListNeuronsResponse;
    list_node_provider_rewards : shared query ListNodeProviderRewardsRequest -> async ListNodeProviderRewardsResponse;
    list_node_providers : shared query () -> async ListNodeProvidersResponse;
    list_proposals : shared query ListProposalInfo -> async ListProposalInfoResponse;
    manage_neuron : shared ManageNeuronRequest -> async ManageNeuronResponse;
    settle_community_fund_participation : shared SettleCommunityFundParticipation -> async Result;
    settle_neurons_fund_participation : shared SettleNeuronsFundParticipationRequest -> async SettleNeuronsFundParticipationResponse;
    simulate_manage_neuron : shared ManageNeuronRequest -> async ManageNeuronResponse;
    transfer_gtc_neuron : shared (NeuronId, NeuronId) -> async Result;
    update_node_provider : shared UpdateNodeProvider -> async Result;
  }
}