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
            -- Deal 1 Damage to target Creature. If that Creature is on a Landscape with a Frozen token on it, deal 3 Damage instead.
            local ids = CW.IDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))

            local target = TargetCreature(playerI, ids, 'Choose a creature')
            local creature = GetCreature(target)
            local landscape = STATE.Players[creature.Original.ControllerI].Landscapes[creature.LaneI]

            local damage = 1
            if landscape:IsFrozen() then
                damage = 3
            end
            Common.Damage.ToCreatureBySpell(id, playerI, target, damage)
        end
    )

    return result
end