-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    result:AddActivatedAbility({
        text = 'FLOOP >> Move an exhausted Creature you control to this Landscape (if empty).',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                STATE.Players[playerI].Landscapes[laneI].Creature == nil and
                #Common.ExhaustedCreatures(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = CW.IDs(Common.ExhaustedCreatures(playerI))
            local target = ChooseCreature(playerI, ids, '')
            MoveCreature(target, laneI)
        end
    })

    return result
end