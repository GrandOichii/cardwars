-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Common.DiscardCards(
        result,
        'Discard a card >>> Your Landscape in this Lane loses its type and becomes the type of your choice (except face down) until the start of your next turn.',
        1,
        function (me, playerI, laneI)
            local landscape = STATE.Players[playerI].Landscapes[laneI]
            if landscape.Original.FaceDown then
                return
            end

            local options = {}
            for _, value in pairs(CardWars.Landscapes) do
                options[#options+1] = value
            end
            local choice = PickString(playerI, options, 'Choose a landscape type to turn your lane into')
            UntilNextTurn(playerI, function (layer)
                if layer == CardWars.ModificationLayers.LANDSCAPE_TYPE then
                    STATE.Players[playerI].Landscapes[laneI].Name = choice
                end
            end)
        end
    )

    return result
end