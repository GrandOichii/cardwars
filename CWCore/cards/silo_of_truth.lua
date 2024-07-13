-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'Pay 2 Actions >>> Steal a random card from your opponent and play it at no cost.',
        CW.ActivatedAbility.Cost.PayActionPoints(2),
        function (me, playerI, laneI)
            local opponent = 1 - playerI
            local cards = STATE.Players[opponent].Hand
            if cards.Count == 0 then
                return
            end

            local idx = Random(0, cards.Count)
            local card = RemoveCardFromHand(opponent, idx)
            UpdateState()

            PlayCardIfPossible(playerI, card, true)
        end
    )

    return result
end