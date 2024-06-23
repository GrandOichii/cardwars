-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Each time Repelling Rock Crab takes Damage from a Creature, it deals that much Damage to that Creature.
    result:OnDamaged(function (me, playerI, laneI, amount, from)
        if from.type ~= CardWars.DamageSources.CREATURE then
            return
        end
        local id = from.id
        local c = GetCreatureOrDefault(id)
        if c == nil then
            return
        end
        Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, id, amount)
    end)

    return result
end