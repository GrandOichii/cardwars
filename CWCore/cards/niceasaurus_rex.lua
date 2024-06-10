-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, if Niceasaurus Rex has Damage on it, draw a card.

        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI and me.Original.Damage > 0
        end,
        costF = function (me, ownerI, laneI)
            return true
            end,
        effectF = function (me, ownerI, laneI)
            Draw(ownerI, 1)
        end
    })

    return result
end