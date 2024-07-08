-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Heal or deal 1 Damage to target Creature.
            local ids = CW.IDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))

            local target = TargetCreature(playerI, ids, 'Choose a creature')
            local creature = GetCreature(target)
            local accept = YesNo(playerI, 'Heal '..creature.Original.Card.Template.Name..'?')
            if not accept then
                Common.Damage.ToCreatureBySpell(id, playerI, target, 1)
                return
            end

            HealDamage(target, 1)
        end
    )

    return result
end