-- Status: not tested

-- TODO doesn't work
function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Opposing Buildings in this Lane are blank while The Dog is Flooped',
        function (me, playerI, laneI)
            local opponent = 1 - playerI
            local buildings = Common.BuildingsInLane(opponent, laneI)
            local id = me.Original.Card.ID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL then
                    local c = GetCreature(id)
                    if c == nil then
                        return
                    end
                    if not c.Original:IsFlooped() then
                        return
                    end
                    for _, building in ipairs(buildings) do
                        Common.AbilityGrantingRemoval.RemovaAllFromBuilding(building)
                    end
                end
            end)
        end
    )

    return result
end