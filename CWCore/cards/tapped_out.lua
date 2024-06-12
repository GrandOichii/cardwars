
-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Creatures(playerI) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
        -- Target Creature you control has +2 ATK for each exhausted Creature you control (at the time you play this).

        local ids = Common.IDs(Common.Creatures(playerI))
        local target = TargetCreature(playerI, ids, '')
        local amount = #Common.ExhaustedCreatures(playerI)
        UntilEndOfTurn(function (layer)
            if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                local c = GetCreatureOrDefault(target)
                if c == nil then
                    return
                end
                c.Attack = c.Attack + amount * 2
            end
        end)
    end)

    return result
end