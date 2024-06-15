-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.Creatures(playerI)) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Heal up to 3 Damage from target Creature you control.

            local ids = Common.IDs(Common.Targetable(playerI, Common.Creatures(playerI)))
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

            local choice = PickString(playerI, options, 'Heal how much damage from '..c.Original.Card.Template.Name..'?')
            local heal = tonumber(choice)
            HealDamage(target, heal)
        end
    )

    return result
end