-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- TODO not clear - does the second effect resolve if you don't have a creature in this lane?

    -- At the start of your turn, deal 1 or 2 Damage to your Creature in this Lane, then you heal 1 HP (Max 25).
    result:AddTrigger({
        trigger = CardWars.Phases.START,
        checkF = function (me, controllerI, laneI, args)
            return
                args.playerI == controllerI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            local creatures = Common.CreaturesInLane(controllerI, laneI)
            if #creatures == 1 then
                local creature = creatures[1]
                local amount = 1
                local accept = YesNo(controllerI, 'Deal 2 Damage to '..creature.Original.Card.Template.Name..'? (otherwise 1 Damage will be dealt)')
                if accept then
                    amount = 2
                end
                Common.Damage.ToCreatureByBuildingAbility(me.Original.IPID, controllerI, creature.Original.IPID, amount)
            end

            HealHitPoints(controllerI, 1)
        end
    })

    return result
end