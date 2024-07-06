-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Sprucy Lucy has +1 ATK for each Landscape with a Frozen token on it players control.
    Common.State.ModATKDEF(result, function (me)
        local pairs = Common.SplitLandscapesByOwner(Common.AllPlayers.FrozenLandscapes())
        local amount = #pairs[0] + #pairs[1]
        me.Attack = me.Attack + amount
    end)

    return result
end