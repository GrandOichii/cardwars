-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Draw a card for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local landscapes = Common.AllPlayers.FrozenLandscapes()
            Draw(playerI, #landscapes)
        end
    )

    return result
end