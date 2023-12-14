actor {

    let name : Text = "Michał Kozłowski";

    var message : Text = "Web3 is cool!!!";
    var counter : Nat = 0;

    public func counterInc() {
        counter := counter + 1;
    };

    public query func getCounter(): async Nat {
        return counter;
    };

    public func resetCounter() {
        counter := 0;
    };

};