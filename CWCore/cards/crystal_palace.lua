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
                #CW.Targetable.ByBuilding(CW:CreatureFilter():Do(), controllerI, me.Original.IPID) > 0
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            local ipids = CW.IPIDs(CW.Targetable.ByBuilding(CW:CreatureFilter():Do(), controllerI, me.Original.IPID))

            local target = TargetCreature(controllerI, ipids, 'Choose a creature to deal 2 damage to')

            CW.Damage.ToCreatureByBuildingAbility(me.Original.IPID, controllerI, target, 2)
        end
    })

    return result
end