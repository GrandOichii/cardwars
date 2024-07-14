-- Status: not tested, requires a lot

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Tornado Wall of Fire has +3 ATK while Flooped.',
        function (me, playerI, laneI)
            local id = me.Original.Card.ID

            -- !FIXME this shouldn't be until end of turn
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