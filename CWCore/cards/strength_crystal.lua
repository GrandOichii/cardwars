-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'playerIdx',
                target = CW.Spell.Target.Player(
                    function (id, playerI, targets)
                        return 'Choose a player who will draw 5 cards'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Target player draws five cards.

            Draw(targets.playerIdx, 5)
        end
    )


    return result
end