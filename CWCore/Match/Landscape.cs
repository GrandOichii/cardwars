namespace CWCore.Match;

public class Landscape {
    public bool FaceDown { get; set; }
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public InPlayCard? Building { get; set; }

    public Landscape(string name) {
        Name = name;

        Creature = null;
        Building = null;
        FaceDown = false;
    }
}