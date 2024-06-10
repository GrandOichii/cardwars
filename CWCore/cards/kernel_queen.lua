-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- Kernel Queen has +1 ATK for each Flooped Creature you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local creatures = Common:FilterCreatures( function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original:IsFlooped()
            end)

            me.Attack = me.Attack + #creatures
            me.Defence = me.Defence + #creatures
        end

    end)

    return result
end