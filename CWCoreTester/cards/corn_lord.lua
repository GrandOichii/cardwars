

function _Create(props)
    local result = CardWars:Creature(props)

    -- Corn Lord has +1 ATK for each other Cornfield Creature you control. 
    result:AddStateModifier(function (state, me)
        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID
        local cornCreatures = Common.State:FilterCreatures(state, function (creature)
            -- return true
            print(creature.Original.OwnerI == ownerI)
            print(creature.Original.Card.Template.Type)
            print(creature.Original.Card.ID ~= id)
            return creature.Original.OwnerI == ownerI and creature.Original.Card.Template.Landscape == 'Corn' and creature.Original.Card.ID ~= id
        end)
        me.Attack = me.Attack + #cornCreatures
    end)

    return result
end