-- Status: not tested

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
                key = 'landscape',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter()
                            :ControlledBy(playerI)
                            :Empty()
                            :OfLandscapeType(CardWars.Landscapes.BluePlains)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose an empty Blue Plains Landscape to move '..targets.creature.Original.Card.Template.Name..' to'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Move target Creature you control to an empty Blue Plains Landscape you control, and then draw a card.

            MoveCreature(targets.creature.Original.IPID, targets.landscape.Original.Idx)
            Draw(playerI, 1)
        end
    )

    return result
end