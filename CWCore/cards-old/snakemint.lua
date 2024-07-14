-- When Snakemint deals Damage to an opposing player, you heal that many Hit Points. (Cant ' go over 25.)
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result.OnDealDamageP:AddLayer(function (playerI, laneI, amount, creatureId)
        HealHitPoints(playerI, amount)
    end)

    return result
end