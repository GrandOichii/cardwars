-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Each of your Creatures with no Damage has +2 ATK this turn.

            UntilEndOfTurn(function (state)
                local landscapes = state.Players[playerI]
                for i = 1, landscapes.Count do
                    local landscape = landscapes[i - 1]
                    local creature = landscape.Creature
                    if creature ~= nil and creature.Original.Damage == 0 then
                        creature.Attack = creature.Attack + 2
                    end
                end
            end)
        end
    )

    return result
end