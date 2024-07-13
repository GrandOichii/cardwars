-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Return a random Useless Swamp Creature from your discard pile to your hand.
    result.EffectP:AddLayer(
        function (id, playerI)
            local cards = CW.CardsInDiscardPileFilter()
                :Creatures()
                :OfPlayer(playerI)
                :OfLandscapeType(CardWars.Landscapes.UselessSwamp)
                :Do()
            local pair = CW.Common.RandomCardInDiscard(playerI, cards)
            if pair == nil then
                return
            end
            ReturnToHandFromDiscard(playerI, pair.idx)
        end
    )

    return result
end