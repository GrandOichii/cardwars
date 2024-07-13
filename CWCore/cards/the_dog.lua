-- Status: implemented, not sure about the implementation

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.WhileFlooped(
        result,
        'FLOOP >>> Opposing Buildings in this Lane are blank while The Dog is Flooped',
        function (me, layer, zone)
            if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
                local opponent = 1 - me.Original.ControllerI
                local buildings = Common.BuildingsInLane(opponent, me.LaneI)
                if not me.Original:IsFlooped() then
                    return
                end
                for _, building in ipairs(buildings) do
                    CW.AbilityGrantingRemoval.RemovaAllFromBuilding(building)
                end
            end
        end
    )

    return result
end