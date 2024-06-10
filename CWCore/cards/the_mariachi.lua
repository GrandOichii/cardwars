-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- FLOOP >>> Deal 1 Damage to target Creature for each Creature that entered play this turn.

        checkF = function (me, playerI, laneI)
            return Common:CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            -- TODO rework, doesn't count the creatures that were replaced
            local creatures = Common:FilterCreatures( function (creature) return creature.Original.EnteredThisTurn end)
            local amount = #creatures
            local ids = Common:IDs(Common:FilterCreatures( function (creature) return true end))

            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')

            DealDamageToCreature(target, amount)
        end
    })

    return result
end