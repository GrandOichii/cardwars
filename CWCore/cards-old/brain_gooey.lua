-- Status: implemented, could use some more testing

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Brain Gooey enters play, if it replaced a Creature, it has +2 ATK this turn.
        local me = STATE.Players[playerI].Landscapes[laneI].Creature
        if me == nil then
            -- * shouldn't ever happen
            error('tried to fetch myself, but i was nil (Brain Gooey)')
        end

        if replaced then
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(me.Original.Card.ID)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end
    end)

    return result
end