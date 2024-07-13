-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Draw a card for each of your empty Lanes.

            local amount = #CW.LandscapeFilter()
                :ControlledBy(playerI)
                :Empty()
                :Do()

            Draw(playerI, amount)
        end
    )

    return result
end