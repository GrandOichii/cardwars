-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target foe may discard a card. If they do not, deal 2 Damage to each of their Creatures.

            local target = CW.Target.Opponent(playerI)
            if GetHandCount(target) > 0 then
                local accept = YesNo(target, 'Discard a card? (2 Damage to each of your Creatures otherwise)')
                if accept then
                    CW.Discard.ACard(target)
                    return
                end
            end

            local creatures = CW.CreatureFilter():ControlledBy(target):Do()
            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureBySpell(id, playerI, creature.Original.IPID, 2)
            end
        end
    )

    return result
end