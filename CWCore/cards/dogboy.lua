-- Status: not tested
-- TODO copied code from Dragon Foot

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddActivatedEffect({
        -- Discard a card >>> Dogboy has +2 ATK this turn. (Use only once during each of your turns.)

        maxActivationsPerTurn = 1,
        checkF = function (me, playerI, laneI)
            return GetHandCount(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            local cards = GetState().Players[playerI].Hand
            local ids = {}
            for i = 1, cards.Count do
                ids[#ids+1] = i - 1
            end

            local cardI = ChooseCardInHand(playerI, ids, 'Choose a card to discard')
            DiscardFromHand(playerI, cardI)
            return true
        end,
        effectF = function (me, playerI, laneI)
            UntilEndOfTurn(function (state, layer)
                local c = state.Players[playerI].Landscapes[laneI].Creature
                if c == nil then
                    -- * shouldn't ever happen
                    error('tried to fetch myself, but i was nil (Dogboy)')
                end

                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(c.Original.Card.ID)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end
    })

    return result
end