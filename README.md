# Neuro
A Motoko package for basic staking and neuron management.

## Overview
A "neuron" can be considered a type of vault for tokens on the Internet Computer Protocol (ICP) blockchain. Once a neuron is created, it grants the owner the ability to vote on governance proposals and earn rewards. There are two types of governance frameworks on ICP: The Network Nervous System (NNS) and the Service Nervous System (SNS). Recently, smart contracts (canisters) on ICP have been given the permission to stake and control neurons. Given the significant amount of boilerplate code required to set up seamless staking and management of neurons in Motoko, creating a package to abstract this process became necessary.

## Disclaimer
This package is a work in progress and has not undergone extensive testing. It is recommended to conduct your own research and thoroughly test the package before using it in your projects. Use this package at your own risk for the staking and management of neurons.

## Features

- Class-based design simplifies the code ✅
- Enables staking neurons in canisters with a single line of code ✅
- Interfaces for interacting with the governance frameworks ✅
- Interfaces for interacting with neurons ✅
- Stake neurons on the NNS ✅
- Control neurons on the NNS ✅
- Stake neurons on the SNS ✅
- Control neurons on the SNS ✅
- Uses async-star computation types ✅

The goal of this package is to provide the basic and necessary functions to help you stake and control neurons in canisters. It is not intended to include complex functionalities such as staking neurons on behalf of different users or trading neurons. However, you can fork or build upon this package for your own use cases.

It is also not designed to be a comprehensive governance interface and some governance and neuron management functions are intentionally missing. This is why the package is named "neuro" and not "neuron" — allowing someone else to create a more fully-featured package under that name. If you have suggestions or would like to contribute, pull requests are welcome.
  
## Install
```
mops add neuro
```

## Usage

NNS example:

```motoko

...

import { NNS } "mo:neuro";
import NeuroTypes "mo:neuro/types";

...

// Stake a neuron on the NNS:
public func stake_nns_neuron() : async Result.Result<Nat64, Text> {
  let nns = NNS.Governance({
    canister_id = Principal.fromActor(thisCanister);
    nns_canister_id = Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai");
    icp_ledger_canister_id = Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai");
  });

  switch (await* nns.stake({ amount_e8s = 100_000_000 })) {
    case (#ok result) {
      return #ok(result);
    };
    case (#err result) {
      return #err(result);
    };
  };
};

...

// Interact with the neuron
public func get_nns_neuron_information(id: Nat64) : async NeuroTypes.NnsInformationResult {
  let neuron = NNS.Neuron({
    neuron_id = id;
    nns_canister_id = Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai");
  });

  return await* neuron.getInformation();
};

...

```

SNS example:

```motoko

...

import { SNS } "mo:neuro";
import NeuroTypes "mo:neuro/types";

...

// Stake a neuron on an SNS:
public func stake_sns_neuron() : async Result.Result<Blob, Text> {
  let sns = SNS.Governance({
    canister_id = Principal.fromActor(thisCanister);
    sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
    sns_ledger_canister_id = Principal.fromText("2ouva-viaaa-aaaaq-aaamq-cai");
  });

  switch (await* sns.stake({ amount_e8s = 400_000_000 })) {
    case (#ok result) {
      return #ok(result);
    };
    case (#err result) {
      return #err(result);
    };
  };
};

...

// Interact with the neuron
public func get_sns_neuron_information(id: Blob) : async NeuroTypes.SnsNeuronInformation {
  let neuron = SNS.Neuron({
    neuron_id = id;
    sns_canister_id = Principal.fromText("2jvtu-yqaaa-aaaaq-aaama-cai");
  });

  return await* neuron.getInformation();
};

...

```

See the `test` folder for more

## License

The Neuro code is distributed under the terms of the MIT License.

See LICENSE for details.
