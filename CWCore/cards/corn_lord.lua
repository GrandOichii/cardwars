-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- Corn Lord has +1 ATK for each other Cornfield Creature you control. 

        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID

        local cornCreatures = Common.State:FilterCreatures(state, function (creature)
            return
                creature.Original.OwnerI == ownerI and
                creature.Original.Card.Template.Landscape == 'Cornfield' and
                creature.Original.Card.ID ~= id
        end)

        me.Attack = me.Attack + #cornCreatures
    end)

    return result
end