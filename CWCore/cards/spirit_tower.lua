-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        "Pay 1 Action and FLOOP >>> If you control no Creatures in this Lane, move target Creature in this Lane to your side and ready it. At end of turn, return it to its owner's side.",
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.PayActionPoints(1),
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(
                function (me, playerI, laneI)
                    return #CW.CreatureFilter():InLane(laneI):ControlledBy(playerI):Do() == 0
                end
            ),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():InLane(laneI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local creature = targets.creature
            local ipid = creature.Original.IPID
            local controllerI = creature.Original.ControllerI
            local oldLane = creature.LaneI

            if controllerI == playerI then
                MoveCreature(ipid, laneI)
            else
                StealCreature(controllerI, ipid, laneI)
                AtTheEndOfTurn(function ()
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    -- !FIXME what if the lane is taken?
                    StealCreature(1 - controllerI, ipid, oldLane)
                end)
            end

            ReadyCard(ipid)
        end
    )

    return result
end