-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    -- FLOOP >>> Draw a card, and then discard a card. If you discard a Rainbow card this way, gain 1 Action.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            Draw(playerI, 1)
            local discardedI = Common.ChooseAndDiscardCard(playerI)
            UpdateState()
            local card = STATE.Players[playerI].DiscardPile[discardedI]
            if card.Original.Template.Landscape == CardWars.Landscapes.Rainbow then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end