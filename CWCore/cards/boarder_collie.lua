-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Move Boarder Collie to any of your empty Landscapes. If either Landscape in that Lane is Frozen, gain 1 Action.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.LandscapesWithoutCreatures(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local empty = CW.Lanes(Common.LandscapesWithoutCreatures(playerI))
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')
            MoveCreature(me.Original.IPID, lane)
            for i = 0, 1 do
                local l = STATE.Players[i].Landscapes[lane]
                if l:IsFrozen() then
                    AddActionPoints(playerI, 1)
                    return
                end
            end
        end
    })

    return result
end