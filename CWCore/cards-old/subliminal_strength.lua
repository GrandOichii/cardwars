-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.Creatures(playerI)) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Creature you control has +2 ATK this turn for each Spell you played this turn (including this one).

            local ids = CW.IDs(Common.Targetable(playerI, Common.Creatures(playerI)))
            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')
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