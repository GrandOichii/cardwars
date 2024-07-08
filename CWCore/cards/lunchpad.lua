-- FLOOP >>> Draw a card for each Creature that entered play onto this Landscape this turn.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Draw a card for each Creature that entered play onto this Landscape this turn.',
        function (me, playerI, laneI)
            local count = STATE.Players[playerI].Landscapes[laneI].CreaturesEnteredThisTurn.Count
            Draw(playerI, count)
        end
    )

    return result
end