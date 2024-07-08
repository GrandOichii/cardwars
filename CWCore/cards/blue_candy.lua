-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.Creatures(playerI), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Heal up to 3 Damage from target Creature you control.

            local ids = CW.IDs(Common.TargetableBySpell(Common.Creatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose a creature to heal')
            local c = GetCreature(target)

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
            HealDamage(target, heal)
        end
    )

    return result
end