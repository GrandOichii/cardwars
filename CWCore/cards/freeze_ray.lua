-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'landscape',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter()
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a Landscape to freeze'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Freeze target Landscape and then draw a card.

            CW.Freeze.Landscape(targets.landscape.Original.OwnerI, targets.landscape.Original.Idx)
            Draw(playerI, 1)
        end
    )

    return result
end