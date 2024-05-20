import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Account {
  'owner' : [] | [Principal],
  'subaccount' : [] | [Subaccount],
}
export interface DisburseMaturityInProgress {
  'timestamp_of_disbursement_seconds' : bigint,
  'amount_e8s' : bigint,
  'account_to_disburse_to' : [] | [Account],
  'finalize_disbursement_timestamp_seconds' : [] | [bigint],
}
export type DissolveState = { 'DissolveDelaySeconds' : bigint } |
  { 'WhenDissolvedTimestampSeconds' : bigint };
export interface Followees { 'followees' : Array<NeuronId> }
export interface NeuronId { 'id' : Uint8Array | number[] }
export interface NeuronPermission {
  'principal' : [] | [Principal],
  'permission_type' : Int32Array | number[],
}
export type Result = { 'ok' : Uint8Array | number[] } |
  { 'err' : string };
export type Result_1 = { 'ok' : SnsNeuronInformation } |
  { 'err' : string };
export interface SnsNeuronInformation {
  'id' : [] | [NeuronId],
  'staked_maturity_e8s_equivalent' : [] | [bigint],
  'permissions' : Array<NeuronPermission>,
  'maturity_e8s_equivalent' : bigint,
  'cached_neuron_stake_e8s' : bigint,
  'created_timestamp_seconds' : bigint,
  'source_nns_neuron_id' : [] | [bigint],
  'auto_stake_maturity' : [] | [boolean],
  'aging_since_timestamp_seconds' : bigint,
  'dissolve_state' : [] | [DissolveState],
  'voting_power_percentage_multiplier' : bigint,
  'vesting_period_seconds' : [] | [bigint],
  'disburse_maturity_in_progress' : Array<DisburseMaturityInProgress>,
  'followees' : Array<[bigint, Followees]>,
  'neuron_fees_e8s' : bigint,
}
export interface Subaccount { 'subaccount' : Uint8Array | number[] }
export interface Test {
  'get_sns_neuron_information' : ActorMethod<[], Result_1>,
  'stake_sns_neuron' : ActorMethod<[], Result>,
}
export interface _SERVICE extends Test {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
