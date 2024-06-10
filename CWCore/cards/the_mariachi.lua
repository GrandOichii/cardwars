-- Status: Implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Deal 1 Damage to target Creature for each Creature that entered play this turn.

        checkF = function (me, playerI, laneI)
            return Common.State:CanFloop(GetState(), me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local state = GetState()
            local creatures = Common.State:FilterCreatures(state, function (creature) return creature.Original.EnteredThisTurn end)
            local amount = #creatures
            local ids = Common.State:CreatureIDs(state, function (creature) return true end)

            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')

            DealDamageToCreature(target, amount)
        end
    })

    return result
end