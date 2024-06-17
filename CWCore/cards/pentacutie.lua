-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddStateModifier(function (me, layer, zone)
        -- Opponents can't play 0 cost cards.

        if layer == CardWars.ModificationLayers.PLAY_RESTRICTIONS and zone == CardWars.Zones.IN_PLAY then
            local hand = STATE.Players[1 - me.Original.ControllerI].Hand
            for i = 0, hand.Count - 1 do
                if hand[i]:RealCost() == 0 then
                    hand[i].PlayRestrictions:Add('PentacutieEffect')
                end
            end
        end

    end)

    return result
end