-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Creature()

    -- Additional Cost: Discard a card.

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, GetHandCount(playerI) > 0
        end
    )

    result.PayCostsP:AddLayer(function (playerI, handI)
        Common.ChooseAndDiscardCard(playerI)
        return nil, true
    end)

    -- When Field Reaper enters play, move target Creature in this Lane to an adjacent empty Lane on your side.
    result:OnEnter(function(me, playerI, laneI, replaced)
        local ipids = CW.IPIDs(CW.Targetable.ByCreature(
            CW.CreatureFilter()
                :InLane(laneI)
                :Do()
        ))
        local adjacent = CW.LandscapeFilter()
            :ControlledBy(playerI)
            :AdjacentTo(laneI)
            :Empty()
            :Do()
        local options = CW.Lanes(adjacent)

        if #options == 0 then
            return
        end
        local target = TargetCreature(playerI, ipids, 'Choose a creature to move/steal')
        local creature = GetCreature(target)
        local moveTo = ChooseLandscape(playerI, options, {}, 'Choose a landscape to move '..creature.Original.Card.LogFriendlyName..' to')

        if creature.Original.ControllerI == playerI then
            MoveCreature(creature.Original.IPID, moveTo[1])
            return
        end
        StealCreature(1 - playerI, target, moveTo[1])
    end)

    return result
end
