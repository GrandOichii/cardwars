-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'Destroy a Creature you control, FLOOP >>> Draw a card.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Creatures(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            local ipids = CW.IPIDs(Common.Creatures(playerI))
            local target = ChooseCreature(playerI, ipids, 'Choose a Creature to destroy')
            DestroyCreature(target)
            return true
        end,
        effectF = function (me, playerI, laneI)
            Draw(playerI, 1)
        end
    })

    return result
end