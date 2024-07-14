-- Status: implemented, not sure about the implementation

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.WhileFlooped(
        result,
        'FLOOP >>> Opposing Buildings in this Lane are blank while The Dog is Flooped',
        function (me, layer, zone)
            if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL and zone == CardWars.Zones.IN_PLAY then
                local buildings = CW.BuildingFilter()
                    :ControlledByOpponentOf(me.Original.ControllerI)
                    :InLane(me.LaneI)
                    :Do()

                for _, building in ipairs(buildings) do
                    CW.AbilityGrantingRemoval.RemovaAllFromBuilding(building)
                end
            end
        end
    )

    return result
end