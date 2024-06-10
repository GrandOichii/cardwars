-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me, layer)
        -- +2 ATK for each Flooped Creature you control.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI

            local creatures = Common.State:FilterCreatures(state, function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original:IsFlooped()
            end)

            me.Attack = me.Attack + #creatures * 2

        end
    end)

    return result
end