-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.Creatures(playerI), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
        -- Target Creature you control has +2 ATK for each exhausted Creature you control (at the time you play this).

        local ipids = CW.IPIDs(Common.TargetableBySpell(Common.Creatures(playerI), playerI, id))
        local target = TargetCreature(playerI, ipids, '')
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