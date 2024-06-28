-- Status: not tested

function _Create()
    local result = CardWars:Creature()
    -- Weakened Warrior comes into play exhausted and does not ready at the start of your turn. Whenever Weakened Warrior changes Lanes, ready it.

    result:AddStateModifier(function (me, layer, zone)
        -- Weakened Warrior comes into play exhausted ...
        if layer == CardWars.ModificationLayers.ENTER_PLAY_STATE and zone == CardWars.Zones.HAND then
            me.EntersPlayExhausted = true
            return
        end
        -- and does not ready at the start of your turn. 
        if layer == CardWars.ModificationLayers.READY_PRIVILEGES and zone == CardWars.Zones.IN_PLAY then
            me.ReadiesNextTurn = false
            return
        end
    end)

    result:OnMove(function(me, playerI, fromI, toI, wasStolen)
        -- Whenever Weakened Warrior changes Lanes, ready it.

        ReadyCard(me.Original.Card.ID)
    end)


    return result
end