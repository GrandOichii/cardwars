-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    result:AddStateModifier(function (me, layer, zone)
        -- Opposing Creatures in this Lane don't trigger entering or leaving play effects.

        if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
            local creatures = CW.CreatureFilter()
                :OpposingTo(me.Original.ControllerI)
                :InLane(me.LaneI)
                :Do()

            for _, creature in ipairs(creatures) do
                creature.OnEnterEffects:Clear()
                creature.OnLeaveEffects:Clear()
            end
        end

    end)

    return result
end