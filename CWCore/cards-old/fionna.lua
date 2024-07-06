-- Status: not tested

function _Create()
    local result = CardWars:Hero()

    result:AddStateModifier(function (layer, playerI)
        -- While you control only one Landscape type, your Rainbow Creatures have +1 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            if #GetUniqueLandscapeNames(playerI) == 1 then
                local creatures = Common.CreaturesTyped(playerI, CardWars.Landscapes.Rainbow)
                for _, creature in ipairs(creatures) do
                    creature.Attack = creature.Attack + 1
                end
            end
        end
    
    end)

    return result
end