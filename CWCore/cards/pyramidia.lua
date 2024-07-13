-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    -- TODO? is this an intervening if
    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> If you control a Creature in this Lane, gain 1 Action. Use it only to play a Creature into this Lane.',
        function (me, playerI, laneI)
            local existing = CW.CreatureFilter()
                :InLane(laneI)
                :ControlledBy(playerI)
                :Do()
            if #existing == 0 then
                return
            end

            AddRestrictedActionPoint(playerI, function (card, lane)
                if lane == nil then
                    return false
                end
                if card.IsBuilding then
                    return false
                end
                return lane == laneI
            end)
        end
    )

    return result
end