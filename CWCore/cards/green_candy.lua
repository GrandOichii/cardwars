-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Heal or deal 1 Damage to target Creature.

            local ids = Common:IDs(Common:FilterCreatures(function (creature) return true end))
            local target = TargetCreature(playerI, ids, 'Choose a creature')
            local creature = GetCreature(target)

            local accept = YesNo(playerI, 'Heal '..creature.Original.Card.Template.Name..'?')
            if not accept then
                DealDamageToCreature(target, 1)
                return
            end

            HealDamage(target, 1)
        end
    )

    return result
end