-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Pay 1 Action, FLOOP >>> Freeze target Landscape.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                GetPlayer(playerI).Original.ActionPoints >= 1
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            PayActionPoints(playerI, 1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            Common.Freeze.TargetLandscape(playerI)
        end
    })

    return result
end