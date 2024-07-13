-- Status: implemented

function _Create()
    local result = CardWars:Spell()


    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter():ControlledBy(playerI):Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to heal 3 Damage from'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Heal up to 3 Damage from target Creature you control.

            local c = targets.creature
            local ipid = c.Original.IPID

            local healMax = c.Original.Damage
            local options = {}
            if healMax > 3 then
                healMax = 3
            end
            for i = 1, healMax do
                options[#options+1] = ''..i
            end
            if #options == 0 then
                return
            end

            local choice = PickString(playerI, options, 'Heal how much damage from '..c.Original.Card.Template.Name..'?')
            local heal = tonumber(choice)
            HealDamage(ipid, heal)
        end
    )

    return result
end