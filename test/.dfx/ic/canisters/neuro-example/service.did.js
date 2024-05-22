export const idlFactory = ({ IDL }) => {
  const NeuronId = IDL.Record({ 'id' : IDL.Vec(IDL.Nat8) });
  const NeuronPermission = IDL.Record({
    'principal' : IDL.Opt(IDL.Principal),
    'permission_type' : IDL.Vec(IDL.Int32),
  });
  const DissolveState = IDL.Variant({
    'DissolveDelaySeconds' : IDL.Nat64,
    'WhenDissolvedTimestampSeconds' : IDL.Nat64,
  });
  const Subaccount = IDL.Record({ 'subaccount' : IDL.Vec(IDL.Nat8) });
  const Account = IDL.Record({
    'owner' : IDL.Opt(IDL.Principal),
    'subaccount' : IDL.Opt(Subaccount),
  });
  const DisburseMaturityInProgress = IDL.Record({
    'timestamp_of_disbursement_seconds' : IDL.Nat64,
    'amount_e8s' : IDL.Nat64,
    'account_to_disburse_to' : IDL.Opt(Account),
    'finalize_disbursement_timestamp_seconds' : IDL.Opt(IDL.Nat64),
  });
  const Followees = IDL.Record({ 'followees' : IDL.Vec(NeuronId) });
  const SnsNeuronInformation = IDL.Record({
    'id' : IDL.Opt(NeuronId),
    'staked_maturity_e8s_equivalent' : IDL.Opt(IDL.Nat64),
    'permissions' : IDL.Vec(NeuronPermission),
    'maturity_e8s_equivalent' : IDL.Nat64,
    'cached_neuron_stake_e8s' : IDL.Nat64,
    'created_timestamp_seconds' : IDL.Nat64,
    'source_nns_neuron_id' : IDL.Opt(IDL.Nat64),
    'auto_stake_maturity' : IDL.Opt(IDL.Bool),
    'aging_since_timestamp_seconds' : IDL.Nat64,
    'dissolve_state' : IDL.Opt(DissolveState),
    'voting_power_percentage_multiplier' : IDL.Nat64,
    'vesting_period_seconds' : IDL.Opt(IDL.Nat64),
    'disburse_maturity_in_progress' : IDL.Vec(DisburseMaturityInProgress),
    'followees' : IDL.Vec(IDL.Tuple(IDL.Nat64, Followees)),
    'neuron_fees_e8s' : IDL.Nat64,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Vec(IDL.Nat8), 'err' : IDL.Text });
  const Test = IDL.Service({
    'get_canister_wallet_balances' : IDL.Func(
        [],
        [IDL.Record({ 'chat_balance' : IDL.Nat, 'icp_balance' : IDL.Nat })],
        [],
      ),
    'get_canister_wallet_information' : IDL.Func(
        [],
        [
          IDL.Record({
            'icp_legacy_account' : IDL.Text,
            'icrc_account' : IDL.Text,
          }),
        ],
        ['query'],
      ),
    'list_sns_neurons' : IDL.Func([], [IDL.Vec(SnsNeuronInformation)], []),
    'stake_sns_neuron' : IDL.Func([], [Result], []),
  });
  return Test;
};
export const init = ({ IDL }) => { return []; };
