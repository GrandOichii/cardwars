-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Sandhorn Devil enters play, deal 1 Damage to each Creature in play, (including each of your Creatures).

        local ids = CW.IDs(Common.AllPlayers.Creatures())

        for _, id in ipairs(ids) do
            Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, id, 1)
        end
    end)

    return result
end
