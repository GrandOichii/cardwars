-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter():ControlledBy(playerI):DamageGt(4)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to heal 5 Damage from'
                    end
                )
            },
        },
        function (id, playerI, targets)
            HealDamage(targets.creature.Original.IPID, 5)
        end
    )

    return result
end