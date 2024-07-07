-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnLeave(function(id, playerI, laneI, wasReady)
        -- If Bog Bum leaves play while Ready, each opponent discards a random card.

        if not wasReady then
            return
        end
        local opponent = 1 - playerI
        local hand = STATE.Players[opponent].Hand
        if hand.Count == 0 then
            return
        end
        local cardI = Random(0, hand.Count)
        DiscardFromHand(opponent, cardI)
    end)

    return result
end