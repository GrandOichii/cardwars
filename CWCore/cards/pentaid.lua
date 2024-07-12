-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    local filter = function (playerI)
        return Common.FilterCreatures(function (creature)
            return
            creature.Original.ControllerI == playerI and
            creature.Original.Damage >= 5
        end)
    end

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(filter(playerI), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Heal exactly 5 Damage from target Creature you control (no more and no less).

            local ipids = CW.IPIDs(Common.TargetableBySpell(filter(playerI), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a Creature to heal 5 damage from')

            HealDamage(target, 5)
        end
    )

    return result
end