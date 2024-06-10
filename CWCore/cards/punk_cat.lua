-- Status: Implemented
-- TODO? does this effect the opponents creatures?

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- Each Creature that changed Lanes this turn has +2 ATK his turn.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
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

        end
    end)

    return result
end