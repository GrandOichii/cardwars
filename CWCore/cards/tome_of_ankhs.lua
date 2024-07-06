-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Draw a card for each of your empty Lanes.
            -- TODO not clear what "empty" means - without creatures, buildings, or both?

            local amount = #Common.LandscapesWithoutCreatures(playerI)

            Draw(playerI, amount)
        end
    )

    return result
end