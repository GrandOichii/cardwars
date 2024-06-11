-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result, function (playerI)
        return nil, #Common.Creatures(playerI) > 0
    end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Creature you control has +X ATK this turn, where X is the amount of Damage on it.

            local creatures = Common.IDs(Common.Creatures(playerI))
            local target = TargetCreature(playerI, creatures, 'Choose a creature to buff')

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