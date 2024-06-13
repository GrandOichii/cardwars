-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    Common.ActivatedEffects.Floop(result,
        'Pay 2 Actions >>> Steal a random card from your opponent and play it at no cost.',
        function (me, playerI, laneI)
            local opponent = 1 - playerI
            local cards = STATE.Players[opponent].Hand
            if cards.Count == 0 then
                return
            end

            local idx = Random(1, cards.Count + 1)
            local card = RemoveCardFromHand(opponent, idx)

            PlayCardIfPossible(playerI, card, true, false)
        end
    )

    return result
end