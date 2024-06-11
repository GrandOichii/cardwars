-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- !FIXME add check - any creatures in play

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Blue Plains Creature you control has +2 ATK this turn.

            local ids = Common.IDs(Common.CreaturesTyped(playerI, CardWars.Landscapes.BluePlains))
            -- TODO remove
            if #ids == 0 then
                return
            end
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