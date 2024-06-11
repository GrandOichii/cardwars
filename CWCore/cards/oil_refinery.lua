-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Your Creature on this Landscape has +2 DEF for each Oil Refinery you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local creature = STATE.Players[me.Original.OwnerI].Landscapes[me.LaneI].Creature
            if creature == nil then
                return
            end
            creature.Defense = creature.Defense + #Common.BuildingsNamed(me.Original.OwnerI, 'Oil Refinery')
        end

    end)

    return result
end