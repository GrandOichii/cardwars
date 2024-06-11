-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddActivatedEffect({
        -- Pay 1 Action >>> Target Creature in this Lane has -10 ATK this turn.

        checkF = function (me, playerI, laneI)
            return GetPlayer(playerI).Original.ActionPoints >= 1
        end,
        costF = function (me, playerI, laneI)
            PayActionPoints(playerI, -1)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local options = Common.CreaturesInLane(laneI)

            local target = TargetCreature(playerI, options, 'Choose a creature to debuff')

            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack - 10
                    if creature.Attack < 0 then
                        creature.Attack = 0
                    end
                end
            end)
        end
    })

    return result
end