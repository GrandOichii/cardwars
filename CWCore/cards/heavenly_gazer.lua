-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Put a Spell from your discard pile on top of your deck.
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local discard = STATE.Players[playerI].DiscardPile
            local ids = {}
            for i = 1, discard.Count do
                if discard[i - 1].Original.Template.Type == 'Spell' then
                    ids[#ids+1] = i - 1
                end
            end

            -- TODO replace with additional check in activated effect
            if #ids == 0 then
                return
            end

            local choice = ChooseCardInDiscard(playerI, ids, {}, 'Choose a Rainbow card to place on top of your deck')
            local pI = choice[0]
            if pI ~= playerI then
                -- * shouldn't ever happen
                error('tried to pick card in opponent\'s discard')
                return
            end
            local id = choice[1]

            print(playerI, id)
            PlaceFromDiscardOnTopOfDeck(playerI, id)
        end
    )

    return result
end