-- When a SandyLands Creature enters play during your turn (including Shark), it has +1 ATK this turn.

-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, controllerI, laneI, args)
            return args.controllerI == controllerI and args.Original:IsType(CardWars.Landscapes.SandyLands)
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
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