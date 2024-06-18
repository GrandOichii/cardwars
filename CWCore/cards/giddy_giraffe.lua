-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- While Giddy Giraffe has 4 or more Damage on it, it deals Damage directly to your opponent instead of the opposing Creature.
    result:AddStateModifier(function (me, layer, zone)
        -- TODO? add separate zone
        if layer == CardWars.ModificationLayers.DAMAGE_MULTIPLICATION and zone == CardWars.Zones.IN_PLAY then
            if me.Original.Damage < 4 then
                return
            end
            me.IgnoreBlocker = true
        end

    end)

    return result
end