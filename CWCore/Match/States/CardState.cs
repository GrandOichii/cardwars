namespace CWCore.Match.States;

// TODO implement IStateModifier
public class CardState {
    public MatchCard Original { get; }

    public CardState(MatchCard card) {
        Original = card;
    }

    public bool CanPlay(PlayerState player) {
        if (player.Original.Match.Config.CheckLandscapesForPlayingCards) {
            var counts = player.GetLandscapeCounts();
            var landscape = Original.Template.Landscape;

            // TODO replace with field Cost
            if (!counts.ContainsKey(landscape) || counts[landscape] < Original.Template.Cost)
                return false;
        }
        
        // TODO add state-based effects
        return player.Original.ActionPoints >= Original.Template.Cost;
    }

}