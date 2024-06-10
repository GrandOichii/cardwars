namespace CWCore.Match.States;

// TODO add layering - Puppy Parade has to apply it's effect BEFORE any ATK and DEF boosts

public interface IStateModifier {
    public void Modify(MatchState state);
}