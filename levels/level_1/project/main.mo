    import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
actor class DAO() {
    //1 .Define an immutable variable name of type Text that represents the name of your DAO.
    let name: Text = "Kozol DAO name";

    //2. Define a mutable variable manifesto of type Text that represents the manifesto of your DAO.
    var manifesto: Text = "Web3 is cool!!!";

    //3. Implement the getName query function, this function takes no parameters and returns the name of your DAO.
    public shared query func getName() : async Text {
        return name;
    };
    //4. Implement the getManifesto query function, this function takes no parameters and returns the manifesto of your DAO.
    public shared query func getManifesto() : async Text {
        return manifesto;
    };
    //5. Implement the setManifesto function, this function takes a newManifesto of type Text as a parameter, updates the value of manifesto and returns nothing.
    public func setManifesto(newManifesto : Text) : async () {
        manifesto := newManifesto;
        return;
    };
    //6. Define a mutable variable goals of type Buffer<Text> will store the goals of your DAO.
    var goals = Buffer.Buffer<Text>(0); // Creates a new Buffer
    //7. Implement the addGoal function, this function takes a goal of type Text as a parameter, adds a new goal to the goals buffer and returns nothing.
    public func addGoal(newGoal : Text) : async () {
        goals.add(newGoal);
        return;
    };
    //8. Implement the getGoals query function, this function takes no parameters and returns all the goals of your DAO in an Array.

    public shared query func getGoals() : async [Text] {
        let allGoals: [Text] = Buffer.toArray(goals);
        return allGoals;
    };
};
