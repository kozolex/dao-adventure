import Account "account";
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import HashMap "mo:base/HashMap";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
actor class DAO() {

    // To implement the voting logic in this level you need to make use of the code implemented in previous levels.
    // That's why we bring back the code of the previous levels here.

    // For the logic of this level we need to bring back all the previous levels

    ///////////////
    // LEVEL #1 //
    /////////////

    let name : Text = "Motoko Bootcamp DAO";
    var manifesto : Text = "Empower the next wave of builders to make the Web3 revolution a reality";

    let goals : Buffer.Buffer<Text> = Buffer.Buffer<Text>(0);

    public shared query func getName() : async Text {
        return name;
    };

    public shared query func getManifesto() : async Text {
        return manifesto;
    };

    public func setManifesto(newManifesto : Text) : async () {
        manifesto := newManifesto;
        return;
    };

    public func addGoal(newGoal : Text) : async () {
        goals.add(newGoal);
        return;
    };

    public shared query func getGoals() : async [Text] {
        return Buffer.toArray(goals);
    };

    ///////////////
    // LEVEL #2 //
    /////////////

    public type Member = {
        name : Text;
        age : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let dao : HashMap<Principal, Member> = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                return #err("Already a member");
            };
            case (null) {
                dao.put(caller, member);
                return #ok(());
            };
        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.put(caller, member);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.delete(caller);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch (dao.get(p)) {
            case (?member) {
                return #ok(member);
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getAllMembers() : async [Member] {
        return Iter.toArray(dao.vals());
    };

    public query func numberOfMembers() : async Nat {
        return dao.size();
    };

    ///////////////
    // LEVEL #3 //
    /////////////

    public type Subaccount = Blob;
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };

    let nameToken = "Motoko Bootcamp Token";
    let symbolToken = "MBT";

    let ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap(Account.accountsEqual, Account.accountsHash);

    public query func tokenName() : async Text {
        return nameToken;
    };

    public query func tokenSymbol() : async Text {
        return symbolToken;
    };

    public func mint(owner : Principal, amount : Nat) : async () {
        let defaultAccount = { owner = owner; subaccount = null };
        switch (ledger.get(defaultAccount)) {
            case (null) {
                ledger.put(defaultAccount, amount);
            };
            case (?some) {
                ledger.put(defaultAccount, some + amount);
            };
        };
        return;
    };

    public shared ({ caller }) func transfer(from : Account, to : Account, amount : Nat) : async Result<(), Text> {
        let fromBalance = switch (ledger.get(from)) {
            case (null) { 0 };
            case (?some) { some };
        };
        if (fromBalance < amount) {
            return #err("Not enough balance");
        };
        let toBalance = switch (ledger.get(to)) {
            case (null) { 0 };
            case (?some) { some };
        };
        ledger.put(from, fromBalance - amount);
        ledger.put(to, toBalance + amount);
        return #ok();
    };

    public query func balanceOf(account : Account) : async Nat {
        return switch (ledger.get(account)) {
            case (null) { 0 };
            case (?some) { some };
        };
    };

    public query func totalSupply() : async Nat {
        var total = 0;
        for (balance in ledger.vals()) {
            total += balance;
        };
        return total;
    };

    ///////////////
    // LEVEL #4 //
    /////////////

    public type Status = {
        #Open;
        #Accepted;
        #Rejected;
    };

    public type Proposal = {
        id : Nat;
        status : Status;
        manifest : Text;
        votes : Int;
        voters : [Principal];
    };

    public type CreateProposalOk = Nat;

    public type CreateProposalErr = {
        #NotDAOMember;
        #NotEnoughTokens;
    };

    public type createProposalResult = Result<CreateProposalOk, CreateProposalErr>;

    public type VoteOk = {
        #ProposalAccepted;
        #ProposalRefused;
        #ProposalOpen;
    };

    public type VoteErr = {
        #NotDAOMember;
        #NotEnoughTokens;
        #ProposalNotFound;
        #ProposalEnded;
        #AlreadyVoted;
    };

    public type voteResult = Result<VoteOk, VoteErr>;

    /*1. Define a mutable variable nextProposalId of type Nat that will keep track of the next proposal's identifier. 
    Every time a proposal is created, this variable will be incremented by 1.*/
    var nextProposalId : Nat = 0;
    /*2. Define an immutable variable called proposals of type TrieMap<Nat, Proposal>.
    In this datastructure, the keys are of type Nat and represent the unique identifier of each proposal.
     The values are of type Proposal and represent the proposal itself.*/
    let proposals : TrieMap.TrieMap<Nat, Proposal> = TrieMap.TrieMap(Nat.equal, Hash.hash);
    /*3. Implement the createProposal function. 
    This function takes a manifest of type Text as a parameter and returns a CreateProposalResult type.
    This function will be used to create a new proposal. 
    The function should check if the caller is a member of the DAO and if they have enough tokens to create a proposal.
    If that's the case, the function should create a new proposal and return the ProposalCreated case of the
    CreateProposalOk type with the value of the proposal's id field. Otherwise it should return the corresponding error.

    To avoid external malicious users from creating proposals and causing confusion, you will only allow proposals
    to be created by members of the DAO, who own at least 1 tokens. Each proposal creation will cost 1 token and will
    be burned.*/
    func _isMember(caller : Principal) : Bool {
        switch (dao.get(caller)) {
            case (null) { return false };
            case (?some) { return true };
        };
    };
    func _hasEnoughTokens(caller : Principal, amount : Nat) : Bool {
        let defaultAccount = { owner = caller; subaccount = null };
        switch (ledger.get(defaultAccount)) {
            case (null) { return false };
            case (?some) { return some >= 1000 };
        };
    };
    func _burnTokens(caller : Principal, amount : Nat) : () {
        let defaultAccount = { owner = caller; subaccount = null };
        switch (ledger.get(defaultAccount)) {
            case (null) { return };
            case (?some) { ledger.put(defaultAccount, some - amount) };
        };
    };
    public shared ({ caller }) func createProposal(manifest : Text) : async createProposalResult {
        if (not _isMember(caller)) {
            return #err(#NotDAOMember);
        };
        if (not _hasEnoughTokens(caller, 1)) {
            return #err(#NotEnoughTokens);
        };
        let proposal = {
            id = nextProposalId;
            status = #Open;
            manifest = manifest;
            votes = 0;
            voters = [];
        };
        proposals.put(nextProposalId, proposal);
        nextProposalId += 1;
        _burnTokens(caller, 1);
        return #ok(proposal.id);
    };
    /*4. Implement the getProposal query function. 
    This function takes a Nat as an argument and returns the proposal with the corresponding identifier as a ?Proposal.
     If no proposal exists with the given identifier, it should return null.*/
    public query func getProposal(id : Nat) : async ?Proposal {
        return proposals.get(id);
    };
    /*Implement the vote function that takes a Nat and a Bool as arguments and returns a VoteResult type.
    This function will be used to vote on a proposal. 
    The Nat represents the identifier of the proposal and the Bool represents the vote.
    If the Bool is true, the vote is an Up vote. If the Bool is false, the vote is a Down vote. 
    The function should perfom necessary checks before accepting a vote.*/

    public shared ({ caller }) func vote(id : Nat, vote : Bool) : async voteResult {
        if (not _isMember(caller)) {
            return #err(#NotDAOMember);
        };
        if (not _hasEnoughTokens(caller, 1)) {
            return #err(#NotEnoughTokens);
        };
        let proposal = switch (proposals.get(id)) {
            case (null) { return #err(#ProposalNotFound) };
            case (?some) { some };
        };
        if (proposal.status != #Open) {
            return #err(#ProposalEnded);
        };
        for (voter in proposal.voters.vals()) {
            if (voter == caller) {
                return #err(#AlreadyVoted);
            };
        };
        let newVoters = Buffer.fromArray<Principal>(proposal.voters);
        newVoters.add(caller);
        let voteChange = if (vote == true) { 1 } else { -1 };
        let newVote = proposal.votes + voteChange;
        let newStatus = if (newVote >= 10) { #Accepted } else if (newVote <= -10) {
            #Rejected;
        } else { #Open };

        let newProposal : Proposal = {
            id = proposal.id;
            status = newStatus;
            manifest = proposal.manifest;
            votes = newVote;
            voters = Buffer.toArray(newVoters);
        };
        proposals.put(id, newProposal);
        _burnTokens(caller, 1);
        if (newStatus == #Accepted) {
            return #ok(#ProposalAccepted);
        };
        if (newStatus == #Rejected) {
            return #ok(#ProposalRefused);
        };
        return #ok(#ProposalOpen);
    };

    /// DO NOT REMOVE - Used for testing
    public shared query ({ caller }) func whoami() : async Principal {
        return caller;
    };

};
