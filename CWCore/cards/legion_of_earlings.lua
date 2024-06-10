-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Legion of Earlings enters play, you may return target Creature in this Lane to its owner's hand.
        -- TODO duplicated code fron Uni-Knight

        local options = {}
        local players = GetPlayers()
        for i = 1, 2 do
            local player = players[i]
            local lane = player.Landscapes[laneI]
            if lane.Creature ~= nil then
                options[#options+1] = lane.Creature.Original.Card.ID
            end
        end

        local target = TargetCreature(playerI, options, 'Choose a creature to return to hand')
        local creature = GetCreature(target)

        local accept = YesNo(playerI, 'Return '..creature.Original.Card.Template.Name..' to its owner\'s hand?')
        if not accept then
            return
        end

        ReturnCreatureToOwnersHand(target)
    end)

    return result
end
