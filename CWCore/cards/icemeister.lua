-- At the start of your turn, deal 1 Damage to each Creature on a Landscape with a Frozen token on it.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        local creatures = Common.AllPlayers.CreaturesWithFrozenTokens()
        for _, creature in ipairs(creatures) do
            Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, controllerI, creature.Original.Card.ID, 1)
        end
    end)

    return result
end