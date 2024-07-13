-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Play only if you control one or fewer Creatures and have 15 or fewer Hit Points. 
    CW.AddRestriction(result,
    function (id, playerI)
        return nil,
            #CW.CreatureFilter():ControlledBy(playerI):Do() <= 1 and
            GetHitPoints(playerI) <= 15
        end
    )

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to move/steal'
                    end
                )
            },
            {
                key = 'landscape',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter():ControlledBy(playerI):Empty()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a landscape to move '..targets.creature.Original.Card.Template.Name..' to'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Move target Creature to target empty Landscape you control.

            local ipid = targets.creature.Original.IPID
            local lane = targets.landscape.Original.Idx

            local creature = GetCreature(ipid)
            if creature.Original.ControllerI == playerI then
                MoveCreature(ipid, lane)
                return
            end
            StealCreature(creature.Original.ControllerI, ipid, lane)
        end
    )


    return result
end