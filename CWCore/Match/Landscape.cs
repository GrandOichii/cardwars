namespace CWCore.Match;

public class Landscape {
    public string Name { get; set; }
    public Creature? Creature { get; set; }
    public InPlayCard? Building { get; set; }

    public Landscape(string name) {
        Name = name;

        Creature = null;
        Building = null;
    }
}