-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- TODO? on both attack and defense
    -- When Frozen Fish deals Damage to a Creature, you may Freeze a Landscape in this Lane.
    result:OnDealDamage(function (playerI, laneI, amount, creatureIPID)
        if creatureIPID == nil then
            return
        end
        local lane = ChooseLandscape(playerI, {laneI}, {laneI}, 'Choose a Landscape to freeze')
        local accept = YesNo(playerI, 'Freeeze Landscape?')
        if accept then
            CW.Freeze.Landscape(lane[0], lane[1])
        end
    end)

    return result
end