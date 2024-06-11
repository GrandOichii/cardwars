-- Status: partially implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- The opposing Creature in this Lane has -2 DEF.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local landscape = STATE.Players[1 - me.OwnerI].Landscapes[me.LaneI]
            if landscape.Creature ~= nil then
                landscape.Creature.Defense = landscape.Creature.Defense - 2
            end
        end

    end)

    return result
end