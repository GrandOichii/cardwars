-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    local getOptions = function (playerI)
        local options = {}
        local lanes = GetPlayer(playerI).Landscapes
        for i = 1, lanes.Count do
            local lane = lanes[i - 1]
            if lane.Original.FaceDown then
                options[#options+1] = i - 1
            end
        end
        return options
    end

    result:AddActivatedEffect({
        -- FLOOP >>> Flip target face-down Landscape you control face up. 

        checkF = function (me, playerI)
            if me.Original:IsFlooped() then
                return false
            end
            return #getOptions(playerI) > 0
        end,
        costF = function (me, playerI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI)
            local options = getOptions(playerI)

            -- TODO? change to target
            local lane = ChooseLane(playerI, options, {}, 'Choose a face-down Landscape to flip')
            TurnLandscapeFaceUp(lane[0], lane[1])
        end
    })

    return result
end