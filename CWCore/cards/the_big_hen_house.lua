-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    -- TODO not clear - does the second effect resolve if you don't have a creature in this lane?
    
    -- At the start of your turn, deal 1 or 2 Damage to your Creature in this Lane, then you heal 1 HP (Max 25).
    result:AddTrigger({
        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, ownerI, laneI, args)
            return
                args.playerI == ownerI
        end,
        costF = function (me, ownerI, laneI, args)
            return true
        end,
        effectF = function (me, ownerI, laneI, args)
            local creatures = Common.CreaturesInLane(ownerI, laneI)
            if #creatures == 1 then
                local creature = creatures[1]
                local amount = 1
                local accept = YesNo(ownerI, 'Deal 2 Damage to '..creature.Original.Card.Template.Name..'? (otherwise 1 Damage will be dealt)')
                if accept then
                    amount = 2
                end
                DealDamageToCreature(creature.Original.Card.ID, amount)
            end

            HealHitPoints(ownerI, 1)
        end
    })

    return result
end