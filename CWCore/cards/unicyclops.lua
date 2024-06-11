-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, each player draws a card and then discards a card.

        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            for i = 0, 1 do
                Draw(i, 1)
                Common.ChooseAndDiscardCard(i, 1)
            end
        end
    })

    return result
end