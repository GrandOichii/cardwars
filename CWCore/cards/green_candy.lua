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
                        return CW.CreatureFilter():Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to heal/deal 1 Damage to'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Heal or deal 1 Damage to target Creature.
            local creature = targets.creature
            local ipid = creature.Original.IPID
            local accept = YesNo(playerI, 'Heal '..creature.Original.Card.Template.Name..'?')
            if not accept then
                CW.Damage.ToCreatureBySpell(id, playerI, ipid, 1)
                return
            end

            HealDamage(ipid, 1)
        end
    )

    return result
end