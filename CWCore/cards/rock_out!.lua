-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            local options = Common.AllPlayers.AvailableToFlipDownLandscapes(playerI)
            return nil, (#options[1] + #options[2]) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Flip target Landscape face down until the start of your next turn.
            local os = Common.AllPlayers.AvailableToFlipDownLandscapes(playerI)
            local options = Common.Lanes(os[1])
            local opponentOptions = Common.Lanes(os[2])
            if playerI == 1 then
                options, opponentOptions = opponentOptions, options
            end

            local choice = ChooseLandscape(playerI, options, opponentOptions, 'Choose a Cornfield Landscape to flip face-down')
            TurnLandscapeFaceDown(choice[0], choice[1])

            AtTheStartOfNextTurn(playerI, function ()
                TurnLandscapeFaceUp(choice[0], choice[1])
            end)
        end
    )

    return result
end