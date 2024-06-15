namespace CWCore.Match;

public class Landscape {
    public int OwnerI { get; }
    public int Idx { get; }
    public bool FaceDown { get; set; }
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public InPlayCard? Building { get; set; }
    public List<MatchCard> CreaturesEnteredThisTurn { get; }

    // TODO add option to discard a card to remove a Frozen token
    public List<string> Tokens { get; }

    public Landscape(string name, int ownerI, int idx) {
        Name = name;
        Idx = idx;
        OwnerI = ownerI;

        Creature = null;
        Building = null;
        FaceDown = false;
        Tokens = new();
        CreaturesEnteredThisTurn = new();
    }

    public bool RemoveToken(string token) {
        return Tokens.Remove(token);
    }

    public bool HasToken(string token) {
        return Tokens.Contains(token);
    }
}