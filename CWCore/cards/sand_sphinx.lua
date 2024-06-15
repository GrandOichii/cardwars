-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Return a Creature you control in this Lane to its owner\'s hand.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.CreaturesInLane(playerI, laneI)) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local creatures = Common.IDs(Common.Targetable(playerI, Common.CreaturesInLane(playerI, laneI)))
            local target = TargetCreature(playerI, creatures, 'Choose a creature to return to hand')

            ReturnCreatureToOwnersHand(target)
        end
    })

    return result
end