-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Return a Creature you control in this Lane to its owner\'s hand.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.CreaturesInLane(playerI, laneI), playerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local creatures = CW.IDs(Common.TargetableByCreature(Common.CreaturesInLane(playerI, laneI), playerI, me.Original.Card.ID))

            -- TODO? should this be targeting
            local target = TargetCreature(playerI, creatures, 'Choose a creature to return to hand')

            ReturnCreatureToOwnersHand(target)
        end
    })

    return result
end