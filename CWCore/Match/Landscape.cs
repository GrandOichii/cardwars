namespace CWCore.Match;

public class Landscape {
    public int OwnerI { get; }
    public int Idx { get; }
    public bool FaceDown { get; set; }
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public List<InPlayCard> Buildings { get; set; }
    public List<MatchCard> CreaturesEnteredThisTurn { get; }

    public List<string> Tokens { get; }

    public Landscape(string name, int ownerI, int idx) {
        Name = name;
        Idx = idx;
        OwnerI = ownerI;

        Creature = null;
        Buildings = new();
        FaceDown = false;
        Tokens = new() { "Frozen"};
        CreaturesEnteredThisTurn = new();
    }

    public bool RemoveToken(string token) {
        return Tokens.Remove(token);
    }

    public bool HasToken(string token) {
        return Tokens.Contains(token);
    }
}