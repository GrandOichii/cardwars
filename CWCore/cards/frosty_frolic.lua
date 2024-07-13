-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Target player discards 1 card from her hand for each Landscape with a Frozen token on it she controls."
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
            local landscapes = CW.LandscapeFilter()
                :ControlledBy(idx)
                :IsFrozen()
                :Do()

            CW.Discard.NCards(idx, #landscapes)
        end
    )

    return result
end