-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(result,
        'FLOOP >>> Draw a card, then discard a card.',
        function (me, playerI, laneI)
            Draw(playerI, 1)
            UpdateState()

            -- * hand count still be 0 if no cards in deck!
            CW.Discard.ACard(playerI)
        end
    )

    return result
end