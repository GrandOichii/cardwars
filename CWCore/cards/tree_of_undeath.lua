-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Return a random Creature from your discard pile to your hand.',
        function (me, playerI, laneI)
            local idx = Common.RandomCardInDiscard(playerI, function (card)
                    return card.Original.Template.Type == 'Creature'
                end)
            if idx == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, idx)
        end
    )

    return result
end