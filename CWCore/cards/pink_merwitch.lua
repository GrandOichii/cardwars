-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Discard a card >>> Deal 1 Damage to each opposing Creature. (Use only once during each of your turns.)

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
            local creatures = GetCreatures(1 - playerI)
            for _, creature in ipairs(creatures) do
                DealDamageToCreature(creature.Original.Card.ID, 1)
            end
        end
    })

    return result
end