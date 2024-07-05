-- Status: implemented

function _Create()
    local result = CardWars:Spell()
    
    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.CreaturesTyped(playerI, CardWars.Landscapes.BluePlains), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target Blue Plains Creature you control has +2 ATK this turn.

            local ids = Common.IDs(Common.TargetableBySpell(Common.CreaturesTyped(playerI, CardWars.Landscapes.BluePlains), playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end
    )

    return result
end