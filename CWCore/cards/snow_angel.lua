-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Heal 1 Damage from each of your Creatures for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local amount = #CW.LandscapeFilter():IsFrozen():Do()
            local creatures = CW.CreatureFilter():ControlledBy(playerI)

            for _, creature in ipairs(creatures) do
                HealDamage(creature.Original.IPID, amount)
            end

        end
    )

    return result
end