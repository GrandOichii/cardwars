-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- At the start of your turn, deal 3 Damage to each opponent who was no cards in hand.
    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI)
        local opponents = CW.PlayerFilter():OpponentsOf(controllerI):Do()

        for _, opponent in ipairs(opponents) do
            if opponent.Hand.Count == 0 then
                DealDamageToPlayer(opponent.Original.Idx, 3)
            end
        end
    end)

    return result
end