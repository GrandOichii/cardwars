-- Status: implemented

function _Create(props)
    local result = CardWars:InPlay(props)

    local getOptions = function (playerI, laneI)
        if STATE.Players[playerI].Landscapes[laneI].Creature ~= nil then
            return {}
        end

        local landscapes = Common:AdjacentLandscapes( playerI, laneI)
        local options = {}

        for _, landscape in ipairs(landscapes) do
            if landscape.Creature ~= nil then
                options[#options+1] = landscape
            end
        end

        return options
    end

    result:AddActivatedEffect({
        -- FLOOP >>> Move a Creature in an adjacent Lane to this Lane (if empty).

        checkF = function (me, playerI, laneI)
            if not Common:CanFloop(me) then
                return false
            end
            return #getOptions(playerI, laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local landscapes = getOptions(playerI, laneI)
            local options = {}
            for _, landscape in ipairs(landscapes) do
                options[#options+1] = landscape.Creature.Original.Card.ID
            end

            local choice = ChooseCreature(playerI, options, 'Choose a creature to move to lane '..laneI)
            MoveCreature(choice, laneI)
        end
    })

    return result
end