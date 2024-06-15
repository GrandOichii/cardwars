-- Status: implemented, requires A LOT of testing

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Opposing Creatures in this Lane don't trigger entering or leaving play effects.

        if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
            local creatures = Common.OpposingCreaturesInLane(me.Original.ControllerI, me.LaneI)
            for _, creature in ipairs(creatures) do
                creature.ProcessEnter = false
                creature.ProcessLeave = false
            end
        end

    end)

    return result
end