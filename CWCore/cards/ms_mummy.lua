-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddTrigger({
        -- At the start of you turn, you may return Ms. Mummy to its owner's hand. If you do, target SandyLands Creature you control gains 1 DEF.",

        trigger = CardWars.Phases.START,
        checkF = function (me, controllerI, laneI)
            return GetCurPlayerI() == controllerI
        end,
        costF = function (me, controllerI, laneI)
            local accept = YesNo(controllerI, 'Return Ms.Mummy to its owner\'s hand?')
            if not accept then
                return false
            end
            ReturnCreatureToOwnersHand(me.Original.IPID)
            return true
        end,
        effectF = function (me, controllerI, laneI)
            -- TODO? should this be in check
            local creatures = CW.IPIDs(Common.TargetableByCreature(
                Common.CreaturesTyped(controllerI, CardWars.Landscapes.SandyLands),
                controllerI,
                me.Original.IPID
            ))
            if #creatures == 0 then
                return
            end

            local target = TargetCreature(controllerI, creatures, 'Choose a creature to add 1 DEF to')
            local creature = GetCreature(target)

            Common.GainDefense(creature, 1)
        end
    })

    return result
end