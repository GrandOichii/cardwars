using CWCore.Match.Players;
using CWCore.Utility;

namespace CWCore.Match.States;

public class CardState {
    // TODO for now these are the same, might require to change
    private readonly static string MODIFY_STATE_IN_HAND_FNAME = "ModifyState";
    private readonly static string PLAY_CHECK_FNAME = "CanPlay";
    private readonly static string PAY_COSTS_FNAME = "PayCosts";
    
    public MatchCard Original { get; }
    public int Cost { get; set; }
    public string LandscapeType { get; set; }
    public List<string> PlayRestrictions { get; }
    public Dictionary<int, List<string>> LanePlayRestrictions { get; }

    public CardState(PlayerState owner, MatchCard card) {
        Original = card;
        Cost = RealCost();
        LandscapeType = Original.Template.Landscape;

        PlayRestrictions = new();
        LanePlayRestrictions = new();

        for (int i = 0; i < owner.Landscapes.Count; i++) {
            LanePlayRestrictions.Add(i, new());
        }
    }

    public bool PayCosts(PlayerState player, int? laneI=null) {
        var returned = Original.ExecFunction(PAY_COSTS_FNAME, Original.Data, player.Original.Idx);
        var additionalPayed = LuaUtility.GetReturnAsBool(returned);

        if (!additionalPayed) return false;

        player.PayToPlay(this, laneI);
        return true;
    }

    public bool CanPlay(PlayerState player, bool forFree = false) {
        if (PlayRestrictions.Count > 0) return false;
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
            var landscapes = player.LandscapesAvailableForCreature(this);
            if (landscapes.Count == 0) return false;
        }

        // check if there is free space for buildings
        if (Original.Template.Type == "Building") {
            var landscapes = player.LandscapesAvailableForBuilding(this);
            if (landscapes.Count == 0) return false;
        }

        var result = Original.ExecFunction(PLAY_CHECK_FNAME, Original.Data, player.Original.Idx);
        if (!LuaUtility.GetReturnAsBool(result))
            return false;

        if (forFree) return true;

        return player.CanPayFor(this);
    }

    public bool IsLandscape(string landscape) {
        return LandscapeType == landscape;
    }

    public void Modify(string zone, ModificationLayer layer)
    {
        Original.ExecFunction(MODIFY_STATE_IN_HAND_FNAME, Original.Data, this, (int)layer, zone);
    }

    public int RealCost() => Original.Template.Cost;
}