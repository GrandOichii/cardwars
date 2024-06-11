-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Each adjacent Creature has +2 ATK this turn.

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(id)
                    if c == nil then
                        return
                    end
                    local adjacent = Common.AdjacentCreatures(playerI, c.Original.LaneI)
                    for _, creature in ipairs(adjacent) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    })

    return result
end