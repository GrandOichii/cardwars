-- Status: partially implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (state, me, layer)
        -- The opposing Creature in this Lane has -2 DEF.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local landscape = state.Players[1 - me.OwnerI].Landscapes[me.LaneI]
            if landscape.Creature ~= nil then
                landscape.Creature.Defense = landscape.Creature.Defense - 2
                -- TODO check for dead creatures
            end
        end

    end)

    return result
end