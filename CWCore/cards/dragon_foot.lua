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
            local c = STATE.Players[playerI].Landscapes[laneI].Creature
            if c == nil then
                -- * shouldn't ever happen
                error('tried to fetch myself, but i was nil (Dragon Foot)')
            end
            UntilEndOfTurn(function (layer)

                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(c.Original.Card.ID)
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