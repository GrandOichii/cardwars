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
                        return 'Choose a player'
                    end
                )
            }
        },
        function (id, playerI, targets)
            local idx = targets.playerIdx
            local landscapes = Common.FrozenLandscapes(idx)
            CW.Discard.NCards(idx, #landscapes)
        end
    )

    return result
end