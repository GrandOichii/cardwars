-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Draw a card for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local pairs = Common.SplitLandscapesByOwner(Common.AllPlayers.FrozenLandscapes())
            Draw(playerI, #pairs[0] + #pairs[1])
        end
    )

    return result
end