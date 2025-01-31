import Principal "mo:base/Principal";
import SnswInterface "../interfaces/snsw_interface";

module {

    ///////////////////
    /// SNSW Class: ///
    ///////////////////

    public class Canister({
        snsw_canister_id : Principal;
    }) {
        
        // this class is a useful helper actor for finding all avaliable SNSes

        let Snsw = actor (Principal.toText(snsw_canister_id)) : SnswInterface.Self;

        public func listDeployedSnses() : async* SnswInterface.ListDeployedSnsesResponse {
            return await Snsw.list_deployed_snses({});
        };

        public func getSnsSubnetIds() : async* SnswInterface.GetSnsSubnetIdsResponse {
            return await Snsw.get_sns_subnet_ids({});
        };

        public func getDeployedSnsByProposalId({ proposal_id : Nat64 }) : async* SnswInterface.GetDeployedSnsByProposalIdResponse {
            return await Snsw.get_deployed_sns_by_proposal_id({
                proposal_id = proposal_id;
            });
        };
    };
};
