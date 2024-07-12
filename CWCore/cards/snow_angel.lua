-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Heal 1 Damage from each of your Creatures for each Landscape with a Frozen token on it players control.',
        function (me, playerI, laneI)
            local landscapes = Common.AllPlayers.FrozenLandscapes()
            local amount = #landscapes
            local creatures = Common.Creatures(playerI)
            for _, creature in ipairs(creatures) do
                HealDamage(creature.Original.IPID, amount)
            end
        end
    )

    return result
end