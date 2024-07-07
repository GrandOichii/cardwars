-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- Whenever a foe discards a card, your Creature in this Lane has +1 ATK until the end of turn.
    result:AddTrigger({
        trigger = CardWars.Triggers.DISCARD_FROM_HAND,
        checkF = function (me, controllerI, laneI, args)
            return args.Card.OwnerI == (1 - controllerI)
        end,
        costF = function (me, controllerI, laneI, args)
            return true
        end,
        effectF = function (me, controllerI, laneI, args)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.CreaturesInLane(controllerI, laneI)
                    if #creatures == 0 then
                        return
                    end
                    local creature = creatures[1]
                    creature.Attack = creature.Attack + 1
                end
            end)
            DealDamageToPlayer(args.Card.OwnerI, 1)
        end
    })

    return result
end