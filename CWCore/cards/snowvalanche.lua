-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Deal 2 Damage to each opposing Creature on a Landscape with a Frozen token on it.

            local creatures = CW.CreatureFilter()
                :OpposingTo(playerI)
                :OnFrozenLandscapes()
                :Do()

            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureBySpell(id, playerI, creature.Original.IPID, 2)
            end
        end
    )

    return result
end