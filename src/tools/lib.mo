import Sha256 "mo:sha2/Sha256";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Types "../types";

module {

    // Map domain tag -> bytes (utf8)
    private func domainBytes(d : Types.NeuronDomain) : [Nat8] {
        let s = switch d {
            case (#stake) "neuron-stake";
            case (#split) "split-neuron";
        };
        Blob.toArray(Text.encodeUtf8(s));
    };

    private func domainSize(db : [Nat8]) : [Nat8] = [Nat8.fromNat(db.size())];

    private func controllerBytes(controller : Principal) : [Nat8] = Blob.toArray(Principal.toBlob(controller));

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

    public func computeNeuronSubaccountBytes(
        controller : Principal,
        nonce : Nat64,
        domain : Types.NeuronDomain,
    ) : Blob {
        let hash = Sha256.Digest(#sha256);
        let db = domainBytes(domain);
        hash.writeArray(domainSize(db));
        hash.writeArray(db);
        hash.writeArray(controllerBytes(controller));
        hash.writeArray(bigEndianFromNat64(nonce));
        return hash.sum();
    };

    // motoko version of this: https://github.com/dfinity/ic/blob/0f7973af4283f3244a08b87ea909b6f605d65989/rs/nervous_system/common/src/ledger.rs#L210
    public func computeNeuronStakingSubaccountBytes(controller : Principal, nonce : Nat64) : Blob {
        computeNeuronSubaccountBytes(controller, nonce, #stake);
    };

};
