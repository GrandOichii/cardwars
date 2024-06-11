namespace CWCore.Match.States;

public class CardState : IStateModifier {
    // TODO for now these are the same, might require to change
    private readonly static string MODIFY_STATE_IN_HAND_FNAME = "ModifyState";
    
    public MatchCard Original { get; }
    public int Cost { get; set; }

    public CardState(MatchCard card) {
        Original = card;
        Cost = Original.Template.Cost;
    }

    public bool CanPlay(PlayerState player) {
        // check if have sufficient landscapes
        if (!IsLandscape("Rainbow") && player.Original.Match.Config.CheckLandscapesForPlayingCards) {
            var counts = player.GetLandscapeCounts();
            var landscape = Original.Template.Landscape;

            // TODO don't actually know the rules interaction here
            if (!counts.ContainsKey(landscape) || counts[landscape] < Cost)
                return false;
        }

        // check if there is free space for creatures
        if (Original.Template.Type == "Creature") {
            var landscapes = player.Original.LandscapesAvailableForCreatures();
            if (landscapes.Count == 0) return false;
        }

        // check if there is free space for buildings
        if (Original.Template.Type == "Building") {
            var landscapes = player.Original.LandscapesAvailableForBuildings();
            if (landscapes.Count == 0) return false;
        }

        // TODO add state-based effects
        return player.Original.ActionPoints >= Cost;
    }

    public bool IsLandscape(string landscape) {
        // TODO some effects can change this
        return Original.Template.Landscape == landscape;
    }

    public void Modify(ModificationLayer layer)
    {
        // TODO might change
        Original.ExecFunction(MODIFY_STATE_IN_HAND_FNAME, Original.Data, this, (int)layer, "hand");
    }
}