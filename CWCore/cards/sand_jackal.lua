-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Creature()

    -- While Sand Jackal is on a NiceLands Landscape, when it defeats an opposing Creature, you heal 3 Hit Points.
    result:OnDefeated(
        function (playerI, laneI, original)
            local landscapes = STATE.Players[playerI].Landscapes[laneI]
            if landscapes:Is(CardWars.Landscapes.NiceLands) then
                HealHitPoints(playerI, 3)
            end
            return nil, true
        end
    )

    return result
end