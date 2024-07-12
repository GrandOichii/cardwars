-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Destroy any number of Creatures you control. Draw a card for each Creature destroyed this way.

            local creatures = Common.Creatures(playerI)
            local count = 0
            for _, creature in ipairs(creatures) do
                local accept = YesNo(playerI, 'Destroy '..creature.Original.Card.Template.Name..'?')
                if accept then
                    DestroyCreature(creature.Original.IPID)
                    count = count + 1
                end
            end
            Draw(playerI, count)
        end
    )

    return result
end