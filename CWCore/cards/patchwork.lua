-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Redistribute the Damage on Creatures you control (no Creature can have more Damage than DEF).

            local creatures = Common.Creatures(playerI)
            local totalDamage = 0
            for _, creature in ipairs(creatures) do
                totalDamage = totalDamage + creature.Original.Damage
                creature.Original.Damage = 0
            end
            while totalDamage > 0 do
                for _, creature in ipairs(creatures) do
                    if totalDamage == 0 then
                        break
                    end
                    local options = {}
                    local max = math.min(creature.Defense - creature.Original.Damage, totalDamage)
                    for i = 0, max do
                        options[#options+1] = tostring(i)
                    end
                    local choice = PickString(playerI, options, 'How much damage to move to '..creature.Original.Card.Template.Name..' in lane '..(creature.LaneI + 1)..'?')
                    local damage = tonumber(choice)
                    creature.Original.Damage = creature.Original.Damage + damage
                    totalDamage = totalDamage - damage
                end

            end
        end
    )

    return result
end