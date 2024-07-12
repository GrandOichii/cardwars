-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When a SandyLands Creature enters play under your control, Peach Djinni has +1 ATK this turn.
    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, controllerI, laneI, args)
            return
                args.controllerI == controllerI and
                args.laneI ~= laneI and
                GetCreature(args.Original.IPID):IsType(CardWars.Landscapes.SandyLands)
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
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