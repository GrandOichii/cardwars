-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(result,
        'FLOOP >>> Draw a card for each Creature that entered play onto this Landscape this turn.',
        function (me, playerI, laneI)
            local count = STATE.Players[playerI].Landscapes[laneI].Original.CreaturesEnteredThisTurn.Count
            Draw(playerI, count)
        end
    )

    return result
end