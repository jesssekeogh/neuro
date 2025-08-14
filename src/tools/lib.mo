import Sha256 "mo:sha2/Sha256";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";

module {

    private func nat64to8(n : Nat64) : Nat8 = Nat8.fromIntWrap(Nat64.toNat(n));

    public func bigEndianFromNat64(n : Nat64) : [Nat8] {
        let b = Array.init<Nat8>(8, 0x00);
        b[0] := nat64to8(n >> 56);
        b[1] := nat64to8(n >> 48);
        b[2] := nat64to8(n >> 40);
        b[3] := nat64to8(n >> 32);
        b[4] := nat64to8(n >> 24);
        b[5] := nat64to8(n >> 16);
        b[6] := nat64to8(n >> 8);
        b[7] := nat64to8(n);
        Array.freeze(b);
    };

    // motoko version of this: https://github.com/dfinity/ic/blob/0f7973af4283f3244a08b87ea909b6f605d65989/rs/nervous_system/common/src/ledger.rs#L210
    public func computeNeuronStakingSubaccountBytes(controller : Principal, nonce : Nat64) : Blob {
        let hash = Sha256.Digest(#sha256);
        hash.writeArray([0x0c]);
        hash.writeArray(Blob.toArray(Text.encodeUtf8("neuron-stake")));
        hash.writeArray(Blob.toArray(Principal.toBlob(controller)));
        hash.writeArray(bigEndianFromNat64(nonce)); // needs to be big endian bytes
        return hash.sum();
    };

};
