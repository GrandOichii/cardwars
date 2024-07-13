-- Status: not tested

function _Create()
    local result = CardWars:InPlay()
    
    result:AddActivatedAbility({
        text = 'FLOOP >>> Freeze both Landscapes in this Lane. Use only if no Frozen tokens are in play.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AllPlayers.FrozenLandscapes() == 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            CW.Freeze.Landscape(playerI, laneI)
            CW.Freeze.Landscape(1 - playerI, laneI)
        end
    })

    return result
end