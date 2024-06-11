-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Move a Creature in an adjacent Lane to this Lane (if empty).

        checkF = function (me, playerI, laneI)
            if not Common.CanFloop(me) then
                return false
            end
            if STATE.Players[playerI].Landscapes[laneI].Creature ~= nil then
                return false
            end
            return #Common.AdjacentCreatures(playerI, laneI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local options = Common.IDs(Common.AdjacentCreatures(playerI, laneI))
            local choice = ChooseCreature(playerI, options, 'Choose a creature to move to lane '..laneI)

            MoveCreature(choice, laneI)
        end
    })

    return result
end