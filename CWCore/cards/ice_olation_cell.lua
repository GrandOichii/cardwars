-- Status: implemented, requires testing

function _Create()
    local result = CardWars:InPlay()

    result:AddStateModifier(function (me, layer, zone)
        -- Creatures on Landscapes with a Frozen token on it in this Lane cannot Attack or use abilities.

        if (layer == CardWars.ModificationLayers.ATTACK_RIGHTS or layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL) and zone == CardWars.Zones.IN_PLAY then
            local landscapes = CW.LandscapeFilter():OnLane(me.LaneI):Do()
            for _, landscape in ipairs(landscapes) do
                if landscape:IsFrozen() then
                    local creature = landscape.Creature
                    if creature ~= nil then
                        CW.State.CantAttack(creature)
                        -- TODO what does "use abilities" mean - only activated abilities or ALL abilities (including state modifiers)
                        for i = 0, creature.ActivatedAbilities.Count - 1 do
                            creature.ActivatedAbilities[i].Enabled = false
                        end
                    end
                end
            end
        end

    end)

    return result
end