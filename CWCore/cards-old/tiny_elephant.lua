-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- While in play, Tiny Elephant is also a Rainbow Creature (in addition to Blue Plains).

        if layer == CardWars.ModificationLayers.IN_PLAY_CARD_TYPE and zone == CardWars.Zones.IN_PLAY then
            me.LandscapeTypes:Add(CardWars.Landscapes.Rainbow)
        end

    end)

    return result
end