-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Pay 1 Action >>> Freeze a Landscape in this Lane.


        checkF = function (me, playerI, laneI)
            return GetPlayer(playerI).Original.ActionPoints >= 1
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, -1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local lane = ChooseLandscape(playerI, {laneI}, {laneI}, 'Choose a Landscape to freeze')
            TurnLandscapeFaceUp(lane[0], lane[1])
            Common.FreezeLandscape(lane[0], lane[1])
        end
    })

    return result
end