-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> If your opponent has no Creature in this Lane they discard a card.',
        function (me, playerI, laneI)
            local creatures = Common.CreaturesInLane(1 - playerI, laneI)
            if #creatures == 0 then
                return
            end
            CW.Discard.ACard(1 - playerI)
        end
    )

    return result
end