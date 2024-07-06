-- Status: implemented, could use some more testing

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Brain Gooey enters play, if it replaced a Creature, it has +2 ATK this turn.

        if not replaced then
            return
        end

        UntilEndOfTurn(function (layer)
            if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                local creature = GetCreatureOrDefault(me.Original.Card.ID)
                if creature == nil then
                    return
                end
                creature.Attack = creature.Attack + 2
            end
        end)
    end)

    return result
end