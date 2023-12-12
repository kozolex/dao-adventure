import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
actor class DAO() = this {

    public type Member = {
        name : Text;
        age : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    //1. Define an immutable variable members of type Hashmap<Principal,Member> that will be used to store the members of your DAO. Each principal is associated with a member.
    let members = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);
    //2. Implement the addMember function, this function takes a member of type Member as a parameter, adds a new member to the members HashMap. 
    //The function should check if the caller is already a member. If that's the case use a Result type to return an error message.
    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        if (members.containsKey(caller)) {
        return #err("Caller is already a member");
        } else {
        members.put(caller, member);
        return #ok();
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch(members.get(caller)) {
            case(null) {
                members.put(caller, member)
                return #ok()
              };
            case(? member) {
                return #err("Member not found")
             };
        }
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        return #err("Not implemented");
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        return #err("Not implemented");
    };

    public query func getAllMembers() : async [Member] {
        return [];
    };

    public query func numberOfMembers() : async Nat {
        return 0;
    };

};
