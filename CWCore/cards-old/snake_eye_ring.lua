-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    -- Return a random Useless Swamp Creature from your discard pile to your hand.
    result.EffectP:AddLayer(
        function (playerI)

            local idx = Common.RandomCardInDiscard(playerI, function (card)
                return
                    card.Original.Template.Type == 'Creature' and
                    card.Original.Template.Landscape == CardWars.Landscapes.UselessSwamp
            end)
            if idx == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, idx)
        end
    )

    return result
end