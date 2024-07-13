-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.Targetable.BySpell(Common.AllPlayers.Creatures(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Heal or deal 1 Damage to target Creature.
            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.AllPlayers.Creatures(), playerI, id))

            local target = TargetCreature(playerI, ipids, 'Choose a creature')
            local creature = GetCreature(target)
            local accept = YesNo(playerI, 'Heal '..creature.Original.Card.Template.Name..'?')
            if not accept then
                CW.Damage.ToCreatureBySpell(id, playerI, target, 1)
                return
            end

            HealDamage(target, 1)
        end
    )

    return result
end