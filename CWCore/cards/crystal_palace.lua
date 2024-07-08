-- Status: not tested

function _Create()
    local result = CardWars:InPlay()
    
    result:AddTrigger({
        -- When a Landscape in this Lane becomes Frozen, deal 2 Damage to target Creature.

        trigger = CardWars.Triggers.TOKEN_PLACED_ON_LANDSCAPE,
        checkF = function (me, controllerI, laneI, args)
            return
                args.laneI == laneI and
                args.token == 'Frozen' and
                #Common.TargetableByBuilding(Common.AllPlayers.Creatures(), controllerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            local ids = CW.IDs(Common.TargetableByBuilding(Common.AllPlayers.Creatures(), controllerI, me.Original.Card.ID))

            local target = TargetCreature(controllerI, ids, 'Choose a creature to deal 2 damage to')

            Common.Damage.ToCreatureByBuildingAbility(me.Original.Card.ID, controllerI, target, 2)
        end
    })

    return result
end