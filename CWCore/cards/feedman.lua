-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Feedman enters play, the next Creature you play this turn costs 1 less to play.

        Common.Mod.ModNextCost(playerI, -1, function (card)
            return card.Original.Template.Type == 'Creature'
        end)
    end)

    return result
end