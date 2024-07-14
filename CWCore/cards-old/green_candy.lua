-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Heal or deal 1 Damage to target Creature.

            local ids = CW.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
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