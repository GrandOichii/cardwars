-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Additional Cost: Floop a Creature you control.
    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.ReadiedCreatures(playerI) > 0
        end
    )

    result.PayCostsP:AddLayer(function (playerI, handI)
        local ids = Common.IDs(Common.ReadiedCreatures(playerI))
        local target = TargetCreature(playerI, ids, 'Choose a creature to floop as an additional cost')

        FloopCard(target)
        return nil, true
    end)


    result.EffectP:AddLayer(
        function (id, playerI)
            -- Search your deck for a Building and put it into play. Then shuffle your deck.
            local deckI = Common.SearchDeckFor(playerI, function (card)
                return card.Template.Type == 'Building'
            end)
            local card = STATE.Players[playerI].Original:DeckAsList()[deckI]
            local removed = RemoveFromDeck(playerI, deckI)
            assert(removed, 'Failed to remove deck card idx '..card.LogFriendlyName..' from deck of player ['..playerI..']')

            PlaceBuilding(playerI, CreateState(playerI, card), true)
        end
    )

    return result
end