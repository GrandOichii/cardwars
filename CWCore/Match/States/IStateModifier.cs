namespace CWCore.Match.States;

// TODO implement layering

public enum ModificationLayer {
    ATK_AND_DEF = 1,
    IN_PLAY_CARD_TYPE,
    LANDSCAPE_TYPE,
    CARD_COST,
    ABILITY_GRANTING_REMOVAL,
    LANDSCAPE_FLIP_DOWN_AVAILABILITY,
    DAMAGE_MULTIPLICATION,
    ATTACK_RIGHTS,
    TARGETING_PERMISSIONS,
}

public interface IStateModifier {
    public void Modify(ModificationLayer layer);
}