-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Draw a card for each Flooped Creature you control (including this one).

        checkF = function (me, playerI, laneI)
            return Common.State:CanFloop(GetState(), me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
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