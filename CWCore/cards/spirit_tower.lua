-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    result:AddActivatedAbility({
        -- Pay 1 Action and FLOOP >>> If you control no Creatures in this Lane, move target Creature in this Lane to your side and ready it. At end of turn, return it to its owner's side.

        maxActivationsPerTurn = -1,
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                GetPlayer(playerI).Original.ActionPoints >= 1 and
                #Common.TargetableByBuilding(Common.AllPlayers.Creatures(), playerI, me.Original.IPID) >= 1
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, 1)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local present = Common.CreaturesInLane(playerI, laneI)
            if #present > 0 then
                return
            end
            local ipids = CW.IPIDs(Common.TargetableByBuilding(Common.AllPlayers.Creatures(), playerI, me.Original.IPID))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to move/steal to lane '..laneI)
            local creature = GetCreature(target)
            local controllerI = creature.Original.ControllerI
            local oldLane = creature.LaneI

            if controllerI == playerI then
                MoveCreature(target, laneI)
            else
                StealCreature(controllerI, target, laneI)
                AtTheEndOfTurn(function ()
                    local c = GetCreatureOrDefault(target)
                    if c == nil then
                        return
                    end
                    -- !FIXME what if the lane is taken?
                    StealCreature(1 - controllerI, target, oldLane)
                end)
            end

            ReadyCard(creature.Original.IPID)
        end
    })

    return result
end