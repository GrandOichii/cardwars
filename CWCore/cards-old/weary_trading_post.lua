-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddActivatedEffect({
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
            local ids = Common.IDs(Common.ExhaustedCreatures(playerI))
            local target = ChooseCreature(playerI, ids, '')
            MoveCreature(target, laneI)
        end
    })

    return result
end