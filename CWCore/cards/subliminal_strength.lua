-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target Creature you control has +2 ATK this turn for each Spell you played this turn (including this one).

            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to buff')
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target)
                    if c == nil then
                        return
                    end
                    local count = Common.SpellsPlayedThisTurnCount(playerI)
                    c.Attack = c.Attack + count * 2
                end
            end)
            
        end
    )

    return result
end