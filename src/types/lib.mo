import Result "mo:base/Result";
import IcpGovernanceInterface "../interfaces/nns_interface";
import SnsGovernanceInterface "../interfaces/sns_interface";

module {

    public type Result<X, Y> = Result.Result<X, Y>;

    public type ConfigureResult = Result<(), Text>;

    public type CommandResult = Result<(), Text>;

    // nns:

    public type NnsNeuronId = Nat64;

    public type NnsStakeNeuronResult = Result<NnsNeuronId, Text>;

    public type NnsListNeuronsResponse = IcpGovernanceInterface.ListNeuronsResponse;

    public type NnsSpawnResult = Result<NnsNeuronId, Text>;

    public type NnsInformationResult = Result<NnsNeuronInformation, Text>;

    public type NnsOperation = IcpGovernanceInterface.Operation;

    public type NnsCommand = IcpGovernanceInterface.Command;

    public type NnsNeuronInformation = IcpGovernanceInterface.NeuronInfo and IcpGovernanceInterface.Neuron;

    // sns:

    public type SnsNeuronId = Blob;

    public type SnsStakeNeuronResult = Result<SnsNeuronId, Text>;

    public type SnsNeuronInformation = SnsGovernanceInterface.Neuron;

    public type SnsDisburseMaturityResponse = SnsGovernanceInterface.DisburseMaturityResponse;

    public type SnsAccount = SnsGovernanceInterface.Account;

    public type SnsDisburseMaturityResult = Result<SnsDisburseMaturityResponse, Text>;

    public type SnsSplitResult = Result<SnsNeuronId, Text>;

    public type SnsInformationResult = Result<SnsNeuronInformation, Text>;

    public type SnsOperation = SnsGovernanceInterface.Operation;

    public type SnsCommand = SnsGovernanceInterface.Command;

    public type SnsParameters = SnsGovernanceInterface.NervousSystemParameters;
};
