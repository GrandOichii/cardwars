-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Whenever you draw a card, Blue Ogre has +1 ATK this turn.
    result:AddTrigger({
        trigger = CardWars.Triggers.CARD_DRAW,
        checkF = function (me, controllerI, laneI, args)
            return args.playerI == controllerI
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, contollerI, laneI, args)
            -- TODO? not specified in the card whether it triggers for each individual card being drawn

            local amount = args.amount
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(id)
                    if c == nil then
                        return
                    end
                    c.Attack = c.Attack + amount
                end
            end)
        end
    })


    return result
end