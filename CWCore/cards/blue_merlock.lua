-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card, then discard a card.

        checkF = function (me, playerI, laneI)
            return Common.State:CanFloop(GetState(), me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            Draw(playerI, 1)
            UpdateState()

            local state = GetState()
            local cards = state.Players[playerI].Hand
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