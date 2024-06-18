-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    local choices = function (playerI)
        return Common.DiscardPileCardIndicies(playerI, function (card)
            return
            card.Original.Template.Type == 'Building'
        end)
    end
    
    Common.AddRestriction(result,
    function (id, playerI)
        return nil,
        #choices(playerI) > 0 and
        #Common.LandscapesWithoutBuildings(playerI) > 0
    end
)

result.EffectP:AddLayer(
    function (id, playerI)
            -- Put a Building from your discard pile into play.

            local indicies = choices(playerI)
            local choice = ChooseCardInDiscard(playerI, indicies, {}, 'Choose a Building to put in play')
            local pI = choice[0]
            if pI ~= playerI then
                -- * shouldn't ever happen
                error('tried to pick card in opponent\'s discard (Harvest Moon)')
                return
            end
            local discardI = choice[1]
            local card = STATE.Players[playerI].DiscardPile[discardI]
            RemoveFromDiscard(playerI, discardI)

            PlaceBuilding(playerI, card, true)
        end
    )

    return result
end