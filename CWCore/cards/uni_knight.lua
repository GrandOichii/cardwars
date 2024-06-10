-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Pay 1 Action >>> Target Creature in this Lane has -10 ATK this turn.

        checkF = function (me, playerI, laneI)
            return GetPlayer(playerI).Original.ActionPoints >= 1
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, -1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local options = {}
            local players = GetPlayers()
            for i = 1, 2 do
                local player = players[i]
                local lane = player.Landscapes[laneI]
                if lane.Creature ~= nil then
                    options[#options+1] = lane.Creature.Original.Card.ID
                end
            end

            local target = TargetCreature(playerI, options, 'Choose a creature to debuff')

            UntilEndOfTurn(function (state)
                local creature = GetCreatureOrDefault(target)
                if creature == nil then
                    return
                end
                creature.Attack = creature.Attack - 10
                if creature.Attack < 0 then
                    creature.Attack = 0
                end
            end)
        end
    })

    return result
end