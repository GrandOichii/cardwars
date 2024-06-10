-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- If you played one or more Rainbow cards this turn, Infant Scholar has +3 ATK this turn,

        local ownerI = me.Original.OwnerI
        local player = state.Players[ownerI].Original

        for i = 1, player.CardsPlayedThisTurn.Count do
            if player.CardsPlayedThisTurn[i - 1].Template.Landscape == 'Rainbow' then
                me.Attack = me.Attack + 3
                return
            end
        end
    end)

    return result
end