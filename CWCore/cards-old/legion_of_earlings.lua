-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Legion of Earlings enters play, you may return target Creature in this Lane to its owner's hand.

        local options = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.CreaturesInLane(laneI)))
        if #options == 0 then
            return
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
