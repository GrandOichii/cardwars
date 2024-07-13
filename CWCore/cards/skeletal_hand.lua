-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Discard the top 3 cards of your deck. For each Spell discarded this way, target player discards a card.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Player('playerIdx')
        ),
        function (me, playerI, laneI, targets)
            local milled = Mill(playerI, 3)
            UpdateState()

            local amount = 0
            for _, card in ipairs(milled) do
                if card.Template.Type == 'Spell' then
                    amount = amount + 1
                end
            end

            if amount == 0 then
                return
            end

            CW.Discard.NCards(targets.playerIdx, amount)
        end
    )

    return result
end