-- When a SandyLands Creature enters play during your turn (including Shark), it has +1 ATK this turn.

-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, ownerI, laneI, args)
            return args.ownerI == ownerI and GetCreature(args.id):IsType(CardWars.Landscapes.SandyLands)
        end,
        costF = function (me, ownerI, laneI, args)
            return true
        end,
        effectF = function (me, ownerI, laneI, args)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(args.id)
                    if c == nil then
                        return
                    end
                    c.Attack = c.Attack + 1
                end
            end)
        end
    })


    return result
end