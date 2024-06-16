-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- Creatures in this Lane cannot use Floop abilities.

        if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
            local creatures = Common.AllPlayers.CreaturesInLane(me.LaneI)
            for _, creature in ipairs(creatures) do
                local abilities = creature.ActivatedEffects
                for i = 0, abilities.Count - 1 do
                    local a = abilities[i]
                    if a:HasTag('floop') then
                        a.Enabled = false
                    end
                end
            end
        end
    
    end)

    return result
end