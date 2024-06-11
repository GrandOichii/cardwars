-- Status: not tested, requires a lot

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddActivatedEffect({
        -- FLOOP >>> Tornado Wall of Fire has +3 ATK while Flooped.
    
        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            UntilEndOfTurn(function ( layer)
                local id = me.Original.Card.ID
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreature(id)
                    if creature == nil then
                        return
                    end
                    if creature.Original:IsFlooped() then
                        creature.Attack = creature.Attack + 3
                    end
                end
            end)
        end
    })

    return result
end