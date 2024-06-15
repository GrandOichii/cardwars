-- Status: implemented, requires some more testing

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        text = 'FLOOP >>> Travelin\' Skeleton and another Creature you control change Lanes with each other.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.CreaturesExcept(playerI, me.Original.Card.ID)) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            local ids = Common.IDs(Common.Targetable(playerI, Common.CreaturesExcept(playerI, id)))
            local target = TargetCreature(playerI, ids, 'Choose creatures to swap lanes with '..me.Original.Card.Template.Name)

            SwapCreatures(id, target)
        end
    })

    return result
end