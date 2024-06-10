-- Status: not tested

function _Create(props)
    local result = CardWars:InPlay(props)

    result:AddStateModifier(function ( me, layer)
        -- While your Creature in this Lane has no Damage on it, it has +2 ATK.

        if layer == CardWars.ModificationLayers.ATK_AND_DEF then
            local ownerI = me.Original.OwnerI
            local player = STATE.Players[ownerI]
            local lane = player.Landscapes[me.LaneI]

            if lane.Creature ~= nil and lane.Creature.Original.Damage == 0 then
                lane.Creature.Attack = lane.Creature.Attack + 2
            end

        end
    end)

    return result
end