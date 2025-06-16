import Result "mo:base/Result";
import IcpGovernanceInterface "../interfaces/nns_interface";
import SnsGovernanceInterface "../interfaces/sns_interface";

module {

    // result types for commands and configuration are bare bones
    // only the error is shown, handle the ok result how you want in your code
    public type Result<X, Y> = Result.Result<X, Y>;

    public type ConfigureResult = Result<(), GovernanceError>;

    public type CommandResult = Result<(), GovernanceError>;

    // nns types:

    public type NnsNeuronId = Nat64;

    public type NnsNeuronIdOrSubaccount = IcpGovernanceInterface.NeuronIdOrSubaccount;

    public type NnsNeuronSubaccount = IcpGovernanceInterface.NeuronSubaccount;

    public type NnsStakeNeuronResult = Result<NnsNeuronId, Text>;

    public type NnsListNeuronsResponse = IcpGovernanceInterface.ListNeuronsResponse;

    public type NnsSpawnResult = Result<NnsNeuronId, GovernanceError>;

    public type NnsDisburseMaturityResponse = IcpGovernanceInterface.DisburseMaturityResponse;

    public type NnsDisburseMaturityResult = Result<NnsDisburseMaturityResponse, Text>;

    public type NnsInformationResult = Result<NnsNeuronInformation, Text>;

    public type NnsOperation = IcpGovernanceInterface.Operation;

    public type NnsCommand = IcpGovernanceInterface.ManageNeuronCommandRequest;

    public type GovernanceError = ?IcpGovernanceInterface.GovernanceError;

    public type NnsNeuronInformation = IcpGovernanceInterface.Neuron;

    public type NnsAccount = IcpGovernanceInterface.Account;

    // sns types:

    // SNS neuronIds are blobs and hex encoded on UI's
    // The id's also represent the subaccount (owner is the governance canister) in which the tokens are sent
    public type SnsNeuronId = Blob;

    public type SnsNeuronResult = Result<SnsNeuronInformation, GovernanceError>;

    public type SnsStakeNeuronResult = Result<SnsNeuronId, Text>;

    public type SnsSpawnNeuronResult = Result<SnsNeuronId, GovernanceError>;

    public type SnsNeuronInformation = SnsGovernanceInterface.Neuron;

    public type SnsDisburseMaturityResponse = SnsGovernanceInterface.DisburseMaturityResponse;

    public type SnsAccount = SnsGovernanceInterface.Account;

    public type SnsDisburseMaturityResult = Result<SnsDisburseMaturityResponse, Text>;

    public type SnsSplitResult = Result<SnsNeuronId, Text>;

    public type SnsInformationResult = Result<SnsNeuronInformation, Text>;

    public type SnsOperation = SnsGovernanceInterface.Operation;

    public type SnsCommand = SnsGovernanceInterface.Command;

    public type SnsParameters = SnsGovernanceInterface.NervousSystemParameters;

    public type SnsMetadata = SnsGovernanceInterface.GetMetadataResponse;

    public type SnsTopics = SnsGovernanceInterface.Topic;
};
