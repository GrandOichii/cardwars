-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddStateModifier(function (state, me)
        -- +2 ATK for each Flooped Creature you control.

        local ownerI = me.Original.OwnerI

        local creatures = Common.State:FilterCreatures(state, function (creature)
            return
                creature.Original.OwnerI == ownerI and
                creature.Original:IsFlooped()
        end)

        me.Attack = me.Attack + #creatures * 2
    end)

    return result
end