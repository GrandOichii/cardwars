-- 
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local filter = function (playerI)
        local hand = STATE.Players[playerI].Original.Hand
        local indicies = {}
        for i = 0, hand.Count - 1 do
            local card = hand[i]
            if card.Template.Cost == 0 then
                indicies[#indicies+1] = i
            end
        end

        return indicies
    end

    -- hint = hint or 'Choose a card to discard'
    -- local cards = STATE.Players[playerI].Hand
    -- if cards.Count == 0 then
    --     return nil
    -- end

    -- local ids = {}
    -- for i = 1, cards.Count do
    --     ids[#ids+1] = i - 1
    -- end

    -- local result = ChooseCardInHand(playerI, ids, hint)
    -- local cardId = STATE.Players[playerI].Hand[result].Original.ID

    -- DiscardFromHand(playerI, result)

    -- return cardId

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Each opponent discards a card with cost 0, or reveals a hand with none.',
        function (me, playerI, laneI)
            local idxs = Common.OpponentIdxs(playerI)
            for _, idx in ipairs(idxs) do
                local indicies = filter(idx)
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