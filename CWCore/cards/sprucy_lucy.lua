-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Sprucy Lucy has +1 ATK for each Landscape with a Frozen token on it players control.
    CW.State.ModATKDEF(result, function (me)
        local landscapes = Common.AllPlayers.FrozenLandscapes()
        local amount = #landscapes
        me.Attack = me.Attack + amount
    end)

    return result
end