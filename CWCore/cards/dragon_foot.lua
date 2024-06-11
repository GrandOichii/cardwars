-- Status: implemented, kinda sus code

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Discard a card >>> Dragon Foot has +1 ATK this turn. (Use up to five times during each of your turns.)

        maxActivationsPerTurn = 5,
        checkF = function (me, playerI, laneI)
            return GetHandCount(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            Common.ChooseAndDiscardCard(playerI)
            
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)

                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(id)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 1
                end
            end)
        end
    })

    return result
end