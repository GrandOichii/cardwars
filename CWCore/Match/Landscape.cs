namespace CWCore.Match;

public class Landscape {
    public int Idx { get; }
    public bool FaceDown { get; set; }
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public InPlayCard? Building { get; set; }

    public Landscape(string name, int idx) {
        Name = name;
        Idx = idx;

        Creature = null;
        Building = null;
        FaceDown = false;
    }
}