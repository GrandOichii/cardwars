-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    CW.ActivatedAbility.Common.Floop(result,
        'FLOOP >>> Draw a card, and then discard a card. If you discard a Rainbow card this way, gain 1 Action.',
        function (me, playerI, laneI)
            Draw(playerI, 1)
            UpdateState()

            local discardedId = CW.Discard.ACard(playerI)
            if discardedId == 0 then
                return
            end
            UpdateState()

            local idx = CW.DiscardCardIdx(playerI, discardedId)
            local card = STATE.Players[playerI].DiscardPile[idx]
            if card:IsLandscapeType(CardWars.Landscapes.Rainbow) then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end