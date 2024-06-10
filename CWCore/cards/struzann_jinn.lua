-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function ( me, layer)
        -- +2 ATK for each Flooped Creature you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local creatures = Common:FloopedCreatures(ownerI)
            me.Attack = me.Attack + #creatures * 2

        end
    end)

    return result
end