-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- If you played one or more Rainbow cards this turn, Infant Scholar has +3 ATK this turn,

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then

            local ownerI = me.Original.OwnerI
            local player = state.Players[ownerI].Original

            for i = 1, player.CardsPlayedThisTurn.Count do
                if player.CardsPlayedThisTurn[i - 1].Template.Landscape == 'Rainbow' then
                    me.Attack = me.Attack + 3
                    return
                end
            end

        end
    end)

    return result
end