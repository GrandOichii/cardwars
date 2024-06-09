-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each of your Cornfield Creatures has +1 ATK this turn for each different Landscape type you control.

            UntilEndOfTurn(function (state)
                local creatures = Common.State:FilterCreatures(state, function (creature)
                    return
                        creature.Original.OwnerI == playerI and
                        creature.Original.Card.Template.Landscape == 'Cornfield'
                end)

                local amount = #GetUniqueLandscapeNames(playerI)
                for _, creature in ipairs(creatures) do
                    print(creature)
                    creature.Attack = creature.Attack + amount
                end
            end)
        end
    )

    return result
end