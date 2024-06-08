-- Status: Not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, each player draws a card.

        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            for i = 1, 2 do
                Draw(i - 1, 1)
            end
        end
    })

    return result
end