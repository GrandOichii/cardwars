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
            -- Target Creature you control has +X ATK this turn, where X is the amount of Damage on it.

            local ipids = CW.IPIDs(Common.TargetableBySpell(Common.Creatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to buff')

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + creature.Original.Damage
                end
            end)
        end
    )

    return result
end