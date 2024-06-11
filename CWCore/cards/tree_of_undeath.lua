-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    -- FLOOP >>> Return a random Creature from your discard pile to your hand.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local idx = Common.RandomCardInDiscard(playerI, function (card)
                    return card.Template.Type == 'Creature'
                end)
            if idx == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, idx)
        end
    )

    return result
end