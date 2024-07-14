-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    local filter = function (playerI)
        return CW.CreatureFilter()
            :ControlledBy(playerI)
            :Ready()
            :Do()
    end

    -- Additional Cost: Floop a Creature you control.
    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #filter(playerI) > 0
        end
    )

    result.PayCostsP:AddLayer(function (playerI, handI)
        local ipids = CW.IPIDs(filter(playerI))
        local target = TargetCreature(playerI, ipids, 'Choose a creature to floop as an additional cost')

        FloopCard(target)
        return nil, true
    end)


    result.EffectP:AddLayer(
        function (id, playerI)
            -- Search your deck for a Building and put it into play. Then shuffle your deck.
            local deckI = CW.SearchDeckFor(playerI, function (card)
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