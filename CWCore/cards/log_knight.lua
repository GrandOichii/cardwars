-- FLOOP >>> Put a Building from your hand below this Lane. (If it doesn't already have one.)
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = '',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.BuildingsInLane(playerI, laneI) == 0 and
                #Common.BuildingsInHand(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.BuildingsInHand(playerI)

            local choice = ChooseCardInHand(playerI, ids, 'Choose a building to put in play')
            local card = STATE.Players[playerI].Hand[choice].Original

            RemoveCardFromHand(playerI, choice)

            PlaceBuildingInLane(playerI, laneI, card)
        end
    })

    return result
end