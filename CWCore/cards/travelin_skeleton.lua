-- Status: implemented, requires some more testing

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Travelin' Skeleton and another Creature you control change Lanes with each other.

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me) and #Common.Creatures(playerI) >= 2
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local id = me.Original.Card.ID
            local ids = Common.IDs(Common.CreaturesExcept(playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose creatures to swap lanes with '..me.Original.Card.Template.Name)

            SwapCreatures(id, target)
        end
    })

    return result
end