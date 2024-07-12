-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Flip target face-down Landscape you control face up. ',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            if not Common.CanFloop(me) then
                return false
            end

            return #Common.FaceDownLandscapes(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local options = CW.Lanes(Common.FaceDownLandscapes(playerI))

            -- TODO? change to target
            local lane = ChooseLandscape(playerI, options, {}, 'Choose a face-down Landscape to flip')
            TurnLandscapeFaceUp(lane[0], lane[1])
        end
    })

    return result
end