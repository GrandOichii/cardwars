-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Deal 1 Damage to each opposing Creature.

            local creatures = Common.OpposingCreatures(playerI)
            for _, creature in ipairs(creatures) do
                Common.Damage.ToCreatureBySpell(id, playerI, creature.Original.Card.ID, 1)
            end
        end
    )

    return result
end