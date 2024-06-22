-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Snakemint deals Damage to an opposing player, you heal that many Hit Points. (Cant ' go over 25.)
    result:OnDealDamage(function (playerI, laneI, amount, creatureId)
        if creatureId == nil then
            HealHitPoints(playerI, amount)
        end
    end)

    return result
end