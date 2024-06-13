-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- When a SandyLands Creature enters play under your control, Peach Djinni has +1 ATK this turn.
    result:AddTrigger({
        trigger = CardWars.Triggers.CREATURE_ENTER,
        checkF = function (me, ownerI, laneI, args)
            return
                args.ownerI == ownerI and
                args.laneI ~= laneI and
                args.Original:IsType(CardWars.Landscapes.SandyLands)
        end,
        costF = function (me, ownerI, laneI, args)
            return true
        end,
        effectF = function (me, ownerI, laneI, args)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(id)
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