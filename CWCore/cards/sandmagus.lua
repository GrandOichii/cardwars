-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    result:AddTrigger({
        -- At the start of your turn, you may return Sandmagus to its owner's hand. If you do, each other Creature you control has +1 ATK this turn.

        trigger = CardWars.Phases.START,
        checkF = function (me, controllerI, laneI)
            return GetCurPlayerI() == controllerI
        end,
        costF = function (me, controllerI, laneI)
            local accept = YesNo(controllerI, 'Return' .. me.Original.Card.Template.Name .. 'to its owner\'s hand?')
            if not accept then
                return false
            end
            ReturnCreatureToOwnersHand(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, controllerI, laneI)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creatures = Common.Creatures(controllerI)
                    for _, creature in ipairs(creatures) do
                        creature.Attack = creature.Attack + 1
                    end
                end
            end)
            Draw(controllerI, 2)
        end
    })

    return result
end