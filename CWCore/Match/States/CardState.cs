namespace CWCore.Match.States;

// TODO implement IStateModifier
public class CardState {
    public MatchCard Original { get; }

    public CardState(MatchCard card) {
        Original = card;
    }

    public bool CanPlay(PlayerState player) {
        // TODO add state-based effects
        return player.Original.ActionPoints >= Original.Template.Cost;
    }

}