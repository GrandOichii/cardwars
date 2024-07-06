-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Heal 1 Damage from each of your Creatures for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local pairs = Common.SplitLandscapesByOwner(Common.AllPlayers.FrozenLandscapes())
            local amount = #pairs[0] + #pairs[1]
            local creatures = Common.Creatures(playerI)
            for _, creature in ipairs(creatures) do
                HealDamage(creature.Original.Card.ID, amount)
            end
        end
    )

    return result
end