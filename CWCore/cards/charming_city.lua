-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    result:AddStateModifier(function (me, layer, zone)
        -- All Creatures in this Lane lose their Landscape type and become Rainbow Creatures.

        if layer == CardWars.ModificationLayers.IN_PLAY_CARD_TYPE and zone == CardWars.Zones.IN_PLAY then
            local creatures = CW.CreatureFilter():InLane(me.LaneI):Do()
            for _, creature in ipairs(creatures) do
                creature.LandscapeTypes:Clear()
                creature.LandscapeTypes:Add(CardWars.Landscapes.Rainbow)
            end
        end

    end)

    return result
end