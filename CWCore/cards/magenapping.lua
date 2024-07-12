-- Play only if you control one or fewer Creatures and have 15 or fewer Hit Points. 
-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil,
                #Common.Creatures(playerI) <= 1 and
                GetHitPoints(playerI) <= 15 and
                #Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id) > 0 and
                #Common.LandscapesWithoutCreatures(playerI) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Move target Creature to target empty Landscape you control.

            local ipids = CW.IPIDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))
            local empty = CW.Lanes(Common.LandscapesWithoutCreatures(playerI))

            local ipid = TargetCreature(playerI, ipids, 'Choose a creature to move/steal')
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            local creature = GetCreature(ipid)
            if creature.Original.ControllerI == playerI then
                MoveCreature(ipid, lane)
                return
            end
            StealCreature(creature.Original.ControllerI, ipid, lane)
        end
    )

    return result
end