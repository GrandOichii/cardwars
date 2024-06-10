-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card, then discard a card.

        checkF = function (me, playerI, laneI)
            return Common:CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            Draw(playerI, 1)
            UpdateState()

            -- * hand count still be 0 if no cards in deck!

            local cards = STATE.Players[playerI].Hand
            if cards.Count == 0 then
                return
            end

            local ids = {}
            for i = 1, cards.Count do
                ids[#ids+1] = i - 1
            end

            local cardI = ChooseCardInHand(playerI, ids, 'Choose a card to discard')
            DiscardFromHand(playerI, cardI)
        end
    })

    return result
end