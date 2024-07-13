-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Deal 2 Damage to each opposing Creature on a Landscape with a Frozen token on it.

            -- TODO could be better
            local creatures = Common.AllPlayers.CreaturesWithFrozenTokens()
            for _, creature in ipairs(creatures) do
                if creature.Original.ControllerI ~= playerI then
                    CW.Damage.ToCreatureBySpell(id, playerI, creature.Original.IPID, 2)
                end
            end
        end
    )

    return result
end