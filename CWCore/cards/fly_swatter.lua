-- 
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Each opponent discards a card with cost 0, or reveals a hand with none.',
        function (me, playerI, laneI)
            local players = CW.PlayerFilter():OpponentsOf(playerI):Do()
            for _, player in ipairs(players) do
                local idx = player.Original.Idx
                local indicies = CW.Keys(
                    CW.CardsInHandFilter(idx):CostEq(0):Do()
                )
                if #indicies == 0 then
                    Common.Reveal.Hand(idx)
                else
                    local chosen = ChooseCardInHand(idx, indicies, 'Choose a card with cost 0 to discard')
                    DiscardFromHand(idx, chosen)
                end
            end
        end
    )

    return result
end