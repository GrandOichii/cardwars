-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.CreaturesTyped(playerI, CardWars.Landscapes.UselessSwamp), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target Useless Swamp Creature you control has +2 ATK this turn.
            local ids = Common.IDs(Common.TargetableBySpell(Common.CreaturesTyped(playerI, CardWars.Landscapes.UselessSwamp), playerI, id))

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