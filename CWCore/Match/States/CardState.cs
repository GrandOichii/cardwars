using CWCore.Utility;

namespace CWCore.Match.States;

public class CardState : IStateModifier {
    // TODO for now these are the same, might require to change
    private readonly static string MODIFY_STATE_IN_HAND_FNAME = "ModifyState";
    private readonly static string PLAY_CHECK_FNAME = "CanPlay";
    private readonly static string PAY_COSTS_FNAME = "PayCosts";
    
    public MatchCard Original { get; }
    public int Cost { get; set; }

    public CardState() {}

    public CardState(MatchCard card) {
        Original = card;
        Cost = Original.Template.Cost;
    }

    public bool PayCosts(PlayerState player) {
        var returned = Original.ExecFunction(PAY_COSTS_FNAME, Original.Data, player.Original.Idx);
        var additionalPayed = LuaUtility.GetReturnAsBool(returned);

        if (!additionalPayed) return false;

        player.Original.PayToPlay(this);
        return true;
    }

    public bool CanPlay(PlayerState player, bool forFree = false) {
        // check if have sufficient landscapes
        if (!forFree && !IsLandscape("Rainbow") && player.Original.Match.Config.CheckLandscapesForPlayingCards) {
            var counts = player.GetLandscapeCounts();
            var landscape = Original.Template.Landscape;

            // TODO? don't actually know the rules interaction here - if cost is modified below 0, does card landscape type matter?
            if (!counts.ContainsKey(landscape) || counts[landscape] < Cost)
                return false;
        }

        // check if there is free space for creatures
        if (Original.Template.Type == "Creature") {
            var landscapes = player.LandscapesAvailableForCreatures();
            if (landscapes.Count == 0) return false;
        }

        // check if there is free space for buildings
        if (Original.Template.Type == "Building") {
            var landscapes = player.LandscapesAvailableForBuildings();
            if (landscapes.Count == 0) return false;
        }

        var result = Original.ExecFunction(PLAY_CHECK_FNAME, Original.Data, player.Original.Idx);
        if (!LuaUtility.GetReturnAsBool(result))
            return false;

        return forFree || player.Original.ActionPoints >= Cost;
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