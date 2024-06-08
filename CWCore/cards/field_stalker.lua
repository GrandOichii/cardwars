-- Status: Not implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- TODO add activated abiltity
    result:AddTrigger({
        trigger = CardWars.Triggers.TurnStart,
        checkF = function (me, ownerI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI)
            return true
        end,
        effectF = function (me, ownerI)
            for i = 1, 2 do
                Draw(i - 1, 1)
            end
        end
    })

    return result
end