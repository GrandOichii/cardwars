-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Creature has +2 ATK this turn for each Flooped Creature you control.

            local ids = Common.State:CreatureIDs(GetState(), function (creature) return creature.Original.OwnerI == playerI end)
            local target = TargetCreature(playerI, ids, 'Choose creature to buff')

            UntilEndOfTurn(function (state, layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target)
                    if creature == nil then
                        return
                    end

                    local creatures = Common.State:FloopedCreatures(state, playerI)
                    creature.Attack = creature.Attack + #creatures * 2
                end
            end)
        end
    )

    return result
end