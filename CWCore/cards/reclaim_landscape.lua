-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- You may flip one of your Landscapes face up, and you may move one of your Buildings to one of your Lanes without one."
            local lanes = Common:Lanes(Common:FaceDownLandscapes(playerI))

            if #lanes ~= 0 then
                local lane = ChooseLandscape(playerI, lanes, {}, 'Choose a Cornfield Landscape to flip face-up')
                local accept = YesNo(playerI, 'Flip landscape face-up?')
                if accept then
                    TurnLandscapeFaceUp(lane[0], lane[1])
                end
            end

            local empty = Common:Lanes(Common:LandscapesWithoutBuildings(playerI))
            
            if #empty == 0 then
                
                return
            end
                
            local options = Common:IDs(Common:Buildings(playerI))
            
            if #options == 0 then

                return
            end
            
            local buildingId = ChooseBuilding(playerI, options, 'Choose a building to move')
            local building = GetBuilding(buildingId)

            local accept = YesNo(playerI, 'Move '..building.Original.Card.Template.Name..' to an empty lane?')
            if not accept then
                return
            end

            local newLane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveBuilding(buildingId, newLane)

        end
    )

    return result
end