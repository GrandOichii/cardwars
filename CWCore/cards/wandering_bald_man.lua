-- At the start of your turn, put the top card of your deck into your discard pile.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.Triggers.AtTheStartOfYourTurn(result,
        function (me, ownerI, laneI, args)
            Mill(ownerI, 1)
        end
    )

    return result
end