-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Return a Creature in an adjacent Lane to its owner\'s hand.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AdjacentCreatures(playerI, laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.AdjacentCreatures(playerI, laneI))
            local target = ChooseCreature(playerI, ipids, 'Choose a creature to return to it\'s owners hand')
            ReturnCreatureToOwnersHand(target)
        end
    })

    return result
end