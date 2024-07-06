-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DestroyMe(
        result,
        'Destroy Snow Bunny >>> Freeze target Landscape.',
        function (me, playerI, laneI)
            Common.Freeze.TargetLandscape(playerI)
        end
    )

    return result
end