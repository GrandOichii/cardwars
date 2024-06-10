-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- If one or more other SandyLand Creatures enter play during you turn, Wall of Sand has +2 ATK this turn.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            -- TODO? the "enter play during your turn" kinda scares me
    
            local ownerI = me.Original.OwnerI
            local id = me.Original.Card.ID
    
            local creatures = Common.State:FilterCreatures(state, function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original.Card.Template.Landscape == 'SandyLands' and
                    creature.Original.Card.ID ~= id
            end)
    
            if #creatures > 0 then
                me.Attack = me.Attack + 2
            end
        end

    end)

    return result
end