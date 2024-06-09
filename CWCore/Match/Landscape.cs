namespace CWCore.Match;

public class Landscape {
    public int OwnerI { get; }
    public int Idx { get; }
    public bool FaceDown { get; set; }
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public InPlayCard? Building { get; set; }

    public Landscape(string name, int ownerI, int idx) {
        Name = name;
        Idx = idx;
        OwnerI = ownerI;

        Creature = null;
        Building = null;
        FaceDown = false;
    }
}