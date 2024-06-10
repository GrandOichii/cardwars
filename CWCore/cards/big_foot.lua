-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Flip target face-down Landscape you control face up. 

        checkF = function (me, playerI, laneI)
            if not Common:CanFloop(me) then
                return false
            end

            return #Common:FaceDownLandscapes(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local options = Common:FaceDownLandscapes(playerI)

            -- TODO? change to target
            local lane = ChooseLandscape(playerI, options, {}, 'Choose a face-down Landscape to flip')
            TurnLandscapeFaceUp(lane[0], lane[1])
        end
    })

    return result
end