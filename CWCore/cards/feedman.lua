-- When Feedman enters play, the next Creature you play this turn costs 1 less to play.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When  enters play, 
    
        Common.Mod.ModNextCost(playerI, -2, function (card)
            return card.Original.Template.Type == 'Spell'
        end)
    end)

    return result
end