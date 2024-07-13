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
                        return CW.CreatureFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to deal Damage to'
                    end
                )
            }
        },
        function (id, playerI, targets)
            local creature = targets.creature
            local ipid = creature.Original.IPID
            local landscape = STATE.Players[creature.Original.ControllerI].Landscapes[creature.LaneI]

            local damage = 1
            if landscape:IsFrozen() then
                damage = 3
            end
            CW.Damage.ToCreatureBySpell(id, playerI, ipid, damage)
        end
    )

    return result
end