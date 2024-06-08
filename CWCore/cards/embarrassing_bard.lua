-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        checkF = function (me, playerI)
            return not me.Original:IsFlooped()
        end,
        costF = function (me, playerI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI)
            local ownerI = me.Original.OwnerI
            local state = GetState()
            local creatures = Common.State:FilterCreatures(state, function (creature)
                return
                    creature.Original.OwnerI == ownerI and
                    creature.Original:IsFlooped()
            end)
            Draw(playerI, #creatures)
        end
    })

    return result
end