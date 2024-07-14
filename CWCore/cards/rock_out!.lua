-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Flip target Landscape face down until the start of your next turn.
    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'landscape',
                target = CW.Spell.Target.Landscape(
                    function (id, playerI)
                        return CW.LandscapeFilter():CanBeFlippedDown(playerI)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a Landscape to flip down unitl the start of your next turn'
                    end
                )
            }
        },
        function (id, playerI, targets)
            CW.Landscape.FlipDownUntilNextTurn(playerI, targets.landscape.Original.OwnerI, targets.landscape.Original.Idx)
        end
    )

    return result
end