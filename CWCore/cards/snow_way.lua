-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'landscape1',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose first Landscape to freeze'
                    end
                )
            },
            {
                key = 'landscape2',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose second Landscape to freeze'
                    end
                )
            }
        },
        function (id, playerI, targets)
            CW.Freeze.Landscape(targets.landscape1.Original.OwnerI, targets.landscape1.Original.Idx)
            CW.Freeze.Landscape(targets.landscape2.Original.OwnerI, targets.landscape2.Original.Idx)
        end
    )

    return result
end