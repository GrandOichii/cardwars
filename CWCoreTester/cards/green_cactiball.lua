-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +2 ATK for each Green Cactiball you control.

        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local cornCreatures = Common.State:FilterCreatures(state, function (creature)
            return
                creature.Original.OwnerI == ownerI and
                creature.Original.Card.Template.Name == 'Green Cactiball'
        end)

        me.Attack = me.Attack + #cornCreatures * 2
    end)

    return result
end