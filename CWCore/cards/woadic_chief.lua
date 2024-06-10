-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- Woadic Chief has +2 ATK this turn for each Spell you have played this turn.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local player = state.Players[ownerI].Original

            local count = 0
            for i = 1, player.CardsPlayedThisTurn.Count do
                if player.CardsPlayedThisTurn[i - 1].Template.Type == 'Spell' then
                    count = count + 1
                end
            end

            me.Attack = me.Attack + count * 2

        end
    end)

    return result
end