-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Friendly Creatures have +1 ATK until the start of the Fight Phase. Then each Creature deals Damage equal to its ATK to the opposing Creature in its Lane.

            CW.UntilFightPhase(playerI, function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = CW.CreatureFilter()
                        :Friendly(playerI)
                        :Do()
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 1
                    end
                end
            end)

            -- TODO? change to UpdateState()
            SoftUpdateState()

            local laneCount = STATE.Players[playerI].Landscapes.Count
            for i = 0, laneCount - 1 do
                for pIdx = 0, 1 do
                    local player = STATE.Players[pIdx]
                    local creature = player.Landscapes[i].Creature
                    if creature ~= nil then
                        local attacked = STATE.Players[1 - pIdx].Landscapes[i].Creature
                        if attacked ~= nil then
                            CW.Damage.ToCreatureByCreature(creature.Original.IPID, creature.Original.ControllerI, attacked.Original.IPID, creature.Attack)
                        end
                    end
                end
            end
        end
    )

    return result
end