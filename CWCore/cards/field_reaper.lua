-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Creature()

    -- Additional Cost: Discard a card.

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, GetHandCount(playerI)
        end
    )

    result.PayCostsP:AddLayer(function (playerI, handI)
        Common.ChooseAndDiscardCard(playerI)
        return nil, true
    end)

    -- When Field Reaper enters play, move target Creature in this Lane to an adjacent empty Lane on your side.
    result:OnEnter(function(me, playerI, laneI, replaced)
        local ids = Common.IDs(Common.TargetableByCreature(Common.AllPlayers.CreaturesInLane(laneI), playerI, me.Original.Card.ID))
        local adjacent = Common.AdjacentLandscapes(playerI, laneI)
        local options = {}
        for _, landscape in ipairs(adjacent) do
            if landscape.Creature == nil then
                options[#options+1] = landscape.Original.Idx
            end
        end
        if #options == 0 then
            return
        end
        local target = TargetCreature(playerI, ids, 'Choose a creature to move/steal')
        local creature = GetCreature(target)
        local moveTo = ChooseLandscape(playerI, options, {}, 'Choose a landscape to move '..creature.Original.Card.LogFriendlyName..' to')

        if creature.Original.ControllerI == playerI then
            MoveCreature(creature.Original.Card.ID, moveTo[1])
            return
        end
        StealCreature(1 - playerI, target, moveTo[1])
    end)

    return result
end
