-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Target SandyLands Creature has +2 ATK this turn for each Creature that entered play into an adjacent Lane this turn.

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter()
                            :LandscapeType(CardWars.Landscapes.SandyLands)
                            :ControlledBy(playerI)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to buff'
                    end
                )
            }
        },
        function (id, playerI, targets)
            local ipid = targets.creature.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    local adjacent = CW.LandscapeFilter()
                        :ControlledBy(playerI)
                        :AdjacentTo(c.LaneI)
                        :Do()
                    local amount = 0
                    for _, landscape in ipairs(adjacent) do
                        amount = amount + landscape.Original.CreaturesEnteredThisTurn.Count
                    end

                    c.Attack = c.Attack + amount * 2
                end
            end)
        end
    )

    return result
end