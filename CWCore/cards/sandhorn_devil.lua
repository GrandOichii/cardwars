-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Sandhorn Devil enters play, deal 1 Damage to each Creature in play, (including each of your Creatures).

        local ipids = CW.IPIDs(Common.AllPlayers.Creatures())

        for _, ipid in ipairs(ipids) do
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, ipid, 1)
        end
    end)

    return result
end
