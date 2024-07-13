-- Status: implemented, requires some more testing

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Travelin\' Skeleton and another Creature you control change Lanes with each other.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            local ipid = me.Original.IPID
            return
                Common.CanFloop(me) and
                #CW.Targetable.ByCreature(Common.CreaturesExcept(playerI, ipid), playerI, ipid) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipid = me.Original.IPID
            local ipids = CW.IPIDs(CW.Targetable.ByCreature(Common.CreaturesExcept(playerI, ipid), playerI, ipid))
            local target = TargetCreature(playerI, ipids, 'Choose creatures to swap lanes with '..me.Original.Card.Template.Name)

            SwapCreatures(id, target)
        end
    })

    return result
end