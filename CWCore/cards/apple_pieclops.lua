-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, you may heal or deal 1 Damage to each Creature you control. (Choose for each Creature.)
    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local creatures = Common.Creatures(controllerI)
        for _, creature in ipairs(creatures) do
            local accept = YesNo(controllerI, 'Heal 1 damage to '..creature.Original.Card.Template.Name..'?')
            local ipid = creature.Original.IPID
            if accept then
                HealDamage(ipid, 1)
            end
            accept = YesNo(controllerI, 'Deal 1 damage to '..creature.Original.Card.Template.Name..'?')
            if accept then
                Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, controllerI, ipid, 1)
            end
        end
    end)

    return result
end