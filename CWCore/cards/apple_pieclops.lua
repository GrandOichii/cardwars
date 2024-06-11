-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of your turn, you may heal or deal 1 Damage to each Creature you control. (Choose for each Creature.)

        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, ownerI, laneI, args)
            return args.playerI == ownerI
        end,
        costF = function (me, ownerI, laneI, args)
            return true
        end,
        effectF = function (me, ownerI, laneI, args)
            local ids = Common.IDs(Common.Creatures(ownerI))

            local accept = YesNo(ownerI, 'Heal 1 damage to each Creature you control?')
            if accept then
                for _, id in ipairs(ids) do
                    HealDamage(id, 1)
                end
                return
            end

            accept = YesNo(ownerI, 'Deal 1 damage to each Creature you control?')
            if accept then
                for _, id in ipairs(ids) do
                    DealDamageToCreature(id, 1)
                end
            end 
        end
    })

    return result
end