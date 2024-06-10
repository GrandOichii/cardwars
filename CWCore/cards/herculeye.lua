-- Status: not tested
-- TODO copied code from Dragon Foot

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Discard a card >>> Herculeye has +4 ATK this turn. (Use only once during each of your turns.)

        maxActivationsPerTurn = 1,
        checkF = function (me, playerI, laneI)
            return GetHandCount(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            Common:ChooseAndDiscardCard(playerI)

            return true
        end,
        effectF = function (me, playerI, laneI)
            UntilEndOfTurn(function ( layer)
                local c = STATE.Players[playerI].Landscapes[laneI].Creature
                if c == nil then
                    -- * shouldn't ever happen
                    error('tried to fetch myself, but i was nil (Herculeye)')
                end

                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(c.Original.Card.ID)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 4
                end
            end)
        end
    })

    return result
end