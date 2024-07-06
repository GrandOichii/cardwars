-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- While Immortal Maize Walker is on a Cornfield Landscape, it deals triple Damage.

        if layer == CardWars.ModificationLayers.DAMAGE_MULTIPLICATION and zone == CardWars.Zones.IN_PLAY then
            local landscape = STATE.Players[me.Original.ControllerI].Landscapes[me.LaneI]
            if landscape:Is(CardWars.Landscapes.Cornfield) then
                me.DamageMultiplier = 3
            end
        end
    end)

    return result
end