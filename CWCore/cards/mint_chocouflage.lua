-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- While there is no opposing Creature in this Lane, Mint Chocouflage can't be damaged by your opponent's Spells or Creature abilities.

        if layer == CardWars.ModificationLayers.DAMAGE_MODIFICATION and zone == CardWars.Zones.IN_PLAY then
            local opposing = CW.CreatureFilter():InLane(me.LaneI):OpposingTo(me.Original.ControllerI):Do()
            if #opposing > 0 then
                return
            end
            me.DamageModifiers:Add(function (to, source, amount)
                if source.ownerI == to.Original.ControllerI then
                    return amount
                end
                if source.type == CardWars.DamageSources.SPELL or source.type == CardWars.DamageSources.CREATURE_ABILITY then
                    return 0
                end
                return amount
            end)
        end

    end)

    return result
end