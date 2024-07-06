-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:AddTrigger({
        -- At the start of your turn, if Niceasaurus Rex has Damage on it, draw a card.

        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, controllerI, laneI)
            return GetCurPlayerI() == controllerI and me.Original.Damage > 0
        end,
        costF = function (me, controllerI, laneI)
            return true
            end,
        effectF = function (me, controllerI, laneI)
            Draw(controllerI, 1)
        end
    })

    return result
end