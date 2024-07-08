-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Creature has +2 ATK this turn for each Flooped Creature you control.

            local ids = CW.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))

            local target = TargetCreature(playerI, ids, 'Choose creature to buff')

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target)
                    if creature == nil then
                        return
                    end

                    local creatures = Common.FloopedCreatures(playerI)
                    creature.Attack = creature.Attack + #creatures * 2
                end
            end)
        end
    )

    return result
end