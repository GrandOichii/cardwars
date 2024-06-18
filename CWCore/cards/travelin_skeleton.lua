-- Status: implemented, requires some more testing

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Travelin\' Skeleton and another Creature you control change Lanes with each other.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.CreaturesExcept(playerI, id), playerI, id) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            local ids = Common.IDs(Common.TargetableByCreature(Common.CreaturesExcept(playerI, id), playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose creatures to swap lanes with '..me.Original.Card.Template.Name)

            SwapCreatures(id, target)
        end
    })

    return result
end