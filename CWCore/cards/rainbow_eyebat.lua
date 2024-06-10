-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, you heal 1 Hit Point for each different Landscape type you control. (Can 't go over 25.)

        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            local amount = #GetUniqueLandscapeNames(ownerI)
            HealHitPoints(ownerI, amount)
        end
    })

    return result
end