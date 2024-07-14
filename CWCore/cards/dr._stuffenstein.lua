-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Heal 2 Damage from a Creature on an adjacent Landscape. If Dr. Stuffenstein has 5 or more Damage on it, heal 2 Damage from each of your Creatures instead.',
        function (me, playerI, laneI)
            local ipids = CW.IPIDs(CW.CreatureFilter():ControlledBy(playerI):Do())
            if me.Original.Damage > 5 then
                local choices = CW.IPIDs(CW:CreatureFilter():AdjacentToLane(playerI, laneI):Do())
                local target = ChooseCreature(playerI, choices, 'Choose creature to heal')
                ipids = {target}
            end
            for _, ipid in ipairs(ipids) do
                HealDamage(ipid, 2)
            end
        end
    )

    return result
end