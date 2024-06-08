-- Status: Implemented
-- TODO? does this effect the opponents creatures?

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Each Creature that changed Lanes this turn has +2 ATK his turn.
        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local creatures = Common.State:FilterCreatures(state, function (creature)
            return
                creature.Original.OwnerI == ownerI and
                creature.Original.MovementCount > 0
        end)

        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 2
        end
    end)

    return result
end