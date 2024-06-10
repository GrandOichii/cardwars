-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (me, layer)
        -- Corn Lord has +1 ATK for each other Cornfield Creature you control. 

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID

            local cornCreatures = Common:FilterCreatures(function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original.Card.Template.Landscape == 'Cornfield' and
                    creature.Original.Card.ID ~= id
            end)

            me.Attack = me.Attack + #cornCreatures
        end

    end)

    return result
end