-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- TODO? is this an intervening if
    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> If your opponent has no Creature in this Lane they discard a card.',
        function (me, playerI, laneI)
            local creatures = CW.CreatureFilter()
                :InLane(laneI)
                :OpposingTo(playerI)
                :Do()
            if #creatures > 0 then
                return
            end
            CW.Discard.ACard(1 - playerI)
        end
    )

    return result
end