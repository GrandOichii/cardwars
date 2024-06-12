-- Status: not tested, requires a lot

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Tornado Wall of Fire has +3 ATK while Flooped.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(id)
                    if creature == nil then
                        return
                    end
                    if creature.Original:IsFlooped() then
                        creature.Attack = creature.Attack + 3
                    end
                end
            end)
        end
    )

    return result
end