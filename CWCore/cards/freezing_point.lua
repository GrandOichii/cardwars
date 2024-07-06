-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    result.EffectP:AddLayer(
        function (id, playerI)
            -- Freeze each of your opponent's Landscapes.

            local opponentI = 1 - playerI
            local landscapes = STATE.Players[opponentI].Landscapes
            for i = 0, landscapes.Count - 1 do
                Common.FreezeLandscape(opponentI, i)
            end
        end
    )

    return result
end