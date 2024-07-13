-- Status: not tested
-- TODO? does this count itself

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Destroy Mace Stump >>> Target opponent discards a card for every 5 cards in your discard pile.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.DestroySelf(),
            CW.ActivatedAbility.Cost.Target.Opponent('opponentIdx')
        ),
        function (me, playerI, laneI, targets)
            local amount = STATE.Players[playerI].DiscardPile.Count
            if amount == 0 then
                return
            end
            amount = math.floor(amount / 5)
            CW.Discard.NCards(targets.opponentIdx, amount)
        end
    )

    return result
end