import Sha256 "mo:sha2/Sha256";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Binary "mo:encoding/Binary";

module {

    // motoko version of this: https://github.com/dfinity/ic/blob/0f7973af4283f3244a08b87ea909b6f605d65989/rs/nervous_system/common/src/ledger.rs#L210
    public func computeNeuronStakingSubaccountBytes(controller : Principal, nonce : Nat64) : Blob {
        let hash = Sha256.Digest(#sha256);
        hash.writeArray([0x0c]);
        hash.writeArray(Blob.toArray(Text.encodeUtf8("neuron-stake")));
        hash.writeArray(Blob.toArray(Principal.toBlob(controller)));
        hash.writeArray(Binary.BigEndian.fromNat64(nonce)); // needs to be big endian bytes
        return hash.sum();
    };

};
