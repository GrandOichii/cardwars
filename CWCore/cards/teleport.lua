-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter():ControlledBy(playerI):Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to move'
                    end
                )
            },
            {
                key = 'lane',
                target = CW.Spell.Target.Lane(
                    function (id, playerI)
                        return CW.LaneFilter(playerI):Empty():Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose an empty Lane to move '..targets.creature.Original.Card.Template.Name..' to'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Move one of your Creatures to one of your empty Lanes.

            MoveCreature(targets.creature.Original.IPID, targets.lane)
        end
    )

    return result
end