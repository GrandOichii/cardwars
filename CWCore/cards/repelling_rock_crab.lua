-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Each time Repelling Rock Crab takes Damage from a Creature, it deals that much Damage to that Creature.
    result:OnDamaged(function (me, playerI, laneI, amount, from)
        if from.type ~= CardWars.DamageSources.CREATURE then
            return
        end
        local ipid = from.ipid
        local c = GetCreatureOrDefault(ipid)
        if c == nil then
            return
        end
        CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, id, amount)
    end)

    return result
end