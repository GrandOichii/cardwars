-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, you may heal or deal 1 Damage to each Creature you control. (Choose for each Creature.)
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local ids = CW.IDs(Common.Creatures(controllerI))

        local accept = YesNo(controllerI, 'Heal 1 damage to each Creature you control?')
        if accept then
            for _, id in ipairs(ids) do
                HealDamage(id, 1)
            end
            return
        end

        accept = YesNo(controllerI, 'Deal 1 damage to each Creature you control?')
        if accept then
            for _, id in ipairs(ids) do
                DealDamageToCreature(id, 1)
            end
        end

    end)

    return result
end