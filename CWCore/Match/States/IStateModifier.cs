namespace CWCore.Match.States;

// TODO implement layering

public enum ModificationLayer {
    ATK_AND_DEF = 1,
    IN_PLAY_CARD_TYPE,
    LANDSCAPE_TYPE
}

public interface IStateModifier {
    public void Modify(MatchState state, ModificationLayer layer);
}