-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Each adjacent Creature has +2 ATK this turn.',
        function (me, playerI, laneI)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    local adjacent = Common.AdjacentCreatures(playerI, c.LaneI)
                    for _, creature in ipairs(adjacent) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end