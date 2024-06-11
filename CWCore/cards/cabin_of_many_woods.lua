-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function (me, layer, zone)
        -- Cabin of Many Woods costs 1 less to play for each Flooped Creature you control. Your Creature in the Lane has +5 DEF.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF and zone == CardWars.Zones.IN_PLAY then
            local ownerI = me.Original.OwnerI
            local player = STATE.Players[ownerI]
            local lane = player.Landscapes[me.LaneI]

            if lane.Creature ~= nil then
                lane.Creature.Defense = lane.Creature.Defense + 5
            end
        end

        if layer == CardWars.ModificationLayers.CARD_COST and zone == CardWars.Zones.HAND then
            local ownerI = me.Original.OwnerI
            local count = #Common.FloopedCreatures(ownerI)
            Common.Mod.Cost(me, -count)
        end
    
    end)

    return result
end