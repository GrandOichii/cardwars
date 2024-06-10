-- Status: not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    local getOptions = function (laneI)
        local options = {}
        for i = 1, 2 do
            local lanes = GetPlayer(i - 1).Landscapes
            if lanes[laneI]:Is('Cornfield') then
                options[#options+1] = {laneI}
            end
        end
        return options
    end

    result:AddActivatedEffect({
        -- FLOOP >>> Flip target face-down Landscape you control face up.

        checkF = function (me, playerI, laneI)
            if not Common:CanFloop(me) then
                return false
            end
            return #getOptions(laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local os = getOptions(laneI)
            local options = os[1]
            local opponentOptions = os[2]

            -- TODO? change to target
            local lane = ChooseLandscape(playerI, options, opponentOptions, 'Choose a Cornfield Landscape to flip face-down')
            TurnLandscapeFaceDown(lane[0], lane[1])
        end
    })

    return result
end