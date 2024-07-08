-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddTrigger({
        -- At the start of your turn, you may return Grand Mummy to its owner's hand. If you do, draw two cards.

        trigger = CardWars.Phases.START,
        checkF = function (me, controllerI, laneI)
            return GetCurPlayerI() == controllerI
        end,
        costF = function (me, controllerI, laneI)
            local accept = YesNo(controllerI, 'Return ' .. me.Original.Card.Template.Name .. ' to its owner\'s hand?')
            if not accept then
                return false
            end
            ReturnCreatureToOwnersHand(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, controllerI, laneI)
            Draw(controllerI, 2)
        end
    })

    return result
end