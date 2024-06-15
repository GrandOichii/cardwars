-- Status: not tested
-- TODO add support for "cannot be flipped"

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Flip target Cornfield Landscape in this Lane face down.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            if not Common.CanFloop(me) then
                return false
            end
            local options = Common.AvailableToFlipDownLandscapesInLaneTyped(playerI, CardWars.Landscapes.Cornfield, laneI)
            return #options[1] + #options[2] > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local os = Common.AvailableToFlipDownLandscapesInLaneTyped(playerI, CardWars.Landscapes.Cornfield, laneI)
            local options = Common.Lanes(os[1])
            local opponentOptions = Common.Lanes(os[2])

            -- TODO? change to target
            local lane = ChooseLandscape(playerI, options, opponentOptions, 'Choose a Cornfield Landscape to flip face-down')
            TurnLandscapeFaceDown(lane[0], lane[1])
        end
    })

    return result
end
