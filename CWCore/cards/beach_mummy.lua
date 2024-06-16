-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedEffect({
        text = 'FLOOP >>> Return a Creature in an adjacent Lane to its owner\'s hand.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.AdjacentCreatures(playerI, laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.AdjacentCreatures(playerI, laneI))
            local target = ChooseCreature(playerI, ids, 'Choose a creature to return to it\'s owners hand')
            ReturnCreatureToOwnersHand(target)
        end
    })

    return result
end