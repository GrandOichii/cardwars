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
    DAMAGE_ABSORBTION,
    ADDITIONAL_LANDSCAPES,
    IN_HAND_CARD_TYPE,
    LANE_PLAY_RESTRICTIONS,
}

public interface IStateModifier {
    public void PreModify();
    public void Modify(ModificationLayer layer);
}