-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Put a Building from your hand below this Lane. (If it doesn\'t already have one.)',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #CW.BuildingFilter()
                    :ControlledBy(playerI)
                    :InLane(laneI)
                    :Do() == 0
            end),
            CW.ActivatedAbility.Cost.Choose.CardInHand(
                'card',
                function (me, playerI, laneI)
                    return CW.CardsInHandFilter(playerI)
                        :Buildings()
                        :Do()
                end,
                function (me, playerI, laneI)
                    return 'Choose a Building to place for free'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            RemoveCardFromHand(playerI, targets.card.idx)

            PlaceBuildingInLane(playerI, laneI, targets.card.card)
        end,
        -1
    )

    return result
end