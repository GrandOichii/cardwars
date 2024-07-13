-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Each adjacent Creature has +2 ATK this turn.',
        function (me, playerI, laneI)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    local adjacent = CW.CreatureFilter()
                        :ControlledBy(playerI)
                        :AdjacentToLane(c.LaneI)
                        :Do()
                    for _, creature in ipairs(adjacent) do
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end