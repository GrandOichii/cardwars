-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Choose a Lane. Freeze both Landscapes in that Lane.

            local lanes = {}
            for i = 0, STATE.Players[playerI].Landscapes.Count - 1 do
                lanes[#lanes+1] = i
            end

            local lane = ChooseLane(playerI, lanes, 'Choose an Lane to freeze both Landscapes')
            CW.Freeze.Landscape(playerI, lane)
            CW.Freeze.Landscape(1 - playerI, lane)
        end
    )

    return result
end