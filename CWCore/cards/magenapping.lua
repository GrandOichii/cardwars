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

            local creatures = Common.IDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))
            local empty = CW.Lanes(Common.LandscapesWithoutCreatures(playerI))

            local creatureId = TargetCreature(playerI, creatures, 'Choose a creature to move/steal')
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            local creature = GetCreature(creatureId)
            if creature.Original.ControllerI == playerI then
                MoveCreature(creatureId, lane)
                return
            end
            StealCreature(creature.Original.ControllerI, creatureId, lane)
        end
    )

    return result
end