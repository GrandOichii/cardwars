-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.CreaturesTyped(playerI, CardWars.Landscapes.UselessSwamp)) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Useless Swamp Creature you control has +2 ATK this turn.

            local ids = CW.IDs(Common.Targetable(playerI, Common.CreaturesTyped(playerI, CardWars.Landscapes.UselessSwamp)))
            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target)
                    if c == nil then
                        return
                    end
                    c.Attack = c.Attack + 2
                end
            end)
        end
    )

    return result
end