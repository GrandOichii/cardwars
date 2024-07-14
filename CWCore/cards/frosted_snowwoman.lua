-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    
    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Frosted Snowwoman enters play, Freeze both Landscapes in her Lane.
        local landscapes = CW.LandscapeFilter():OnLane(laneI):Do()
        for _, landscape in ipairs(landscapes) do
            CW.Freeze.Landscape(landscape.Original.OwnerI, landscape.Original.Idx)
        end
    end)

    return result
end