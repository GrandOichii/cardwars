-- Status: not implemented - requires "until end of turn" effects implementation

function _Create(props)
    error('NOT IMPLEMENTED')
    local result = CardWars:Creature(props)
    local target = nil

    result:AddActivatedEffect({
        -- Pay 1 Action >>> Target Creature in this Lane has -10 ATK.

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
                local player = players[i - 1]
                local lane = player.Landscapes[laneI]
            end
            AddActionPoints(playerI, 1)
        end
    })

    result:AddStateModifier(function (state, me)
        -- TODO

        if target == nil then
            return
        end
        -- GetCreature
    end)

    return result
end