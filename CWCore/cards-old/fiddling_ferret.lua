-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Draw a card, and then discard a card. If you discard a Rainbow card this way, gain 1 Action.',
        function (me, playerI, laneI)
            Draw(playerI, 1)
            UpdateState()

            local discardedId = Common.ChooseAndDiscardCard(playerI)
            if discardedId == 0 then
                return
            end
            UpdateState()

            local idx = Common.DiscardCardIdx(playerI, discardedId)
            local card = STATE.Players[playerI].DiscardPile[idx]
            if card.Original.Template.Landscape == CardWars.Landscapes.Rainbow then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end