-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Heal or deal 1 Damage to your Creature in this Lane.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():InLane(laneI):ControlledBy(playerI)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to heal/deal Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local creature = targets.creature
            local ipid = creature.Original.IPID
            local accept = YesNo(playerI, 'Heal 1 damage from '..creature.Original.Card.Template.Name..'?')
            if accept then
                HealDamage(ipid, 1)
                return
            end
            CW.Damage.ToCreatureByBuildingAbility(me.Original.IPID, playerI, ipid, 1)
        end,
        -1
    )

    return result
end