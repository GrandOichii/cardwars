-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Draw a card for each of your empty Lanes.

            local player = GetPlayer(playerI)
            local amount = 0
            local lanes = player.Landscapes
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane.Creature == nil then
                    amount = amount + 1
                end
            end

            Draw(playerI, amount)
        end
    )

    return result
end