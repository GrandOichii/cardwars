namespace CWCore.Match.States;

// TODO implement IStateModifier
public class CardState {
    public MatchCard Original { get; }

    public CardState(MatchCard card) {
        Original = card;
    }

    public bool CanPlay(PlayerState player) {
        // check if have sufficient landscapes
        if (!IsLandscape("Rainbow") && player.Original.Match.Config.CheckLandscapesForPlayingCards) {
            var counts = player.GetLandscapeCounts();
            var landscape = Original.Template.Landscape;

            // TODO replace with field Cost
            if (!counts.ContainsKey(landscape) || counts[landscape] < Original.Template.Cost)
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
        return player.Original.ActionPoints >= Original.Template.Cost;
    }

    public bool IsLandscape(string landscape) {
        // TODO some effects can change this
        return Original.Template.Landscape == landscape;
    }

}