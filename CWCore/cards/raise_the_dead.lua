-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:Spell()

    -- TODO add creature restriction - can't cast if cant replace any creatures
    local choices = function (playerI)
        return Common.DiscardPileCardIndicies(playerI, function (card)
            return
                card.Original.Template.Type == 'Creature' and
                card.Cost <= 2
        end)
    end

    
    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #choices(playerI) > 0
        end
    )

    result.EffectP:AddLayer(
    function (id, playerI)
            -- Put a Creature with cost 2 or less from your discard pile into play.

            local indicies = choices(playerI)
            local choice = ChooseCardInDiscard(playerI, indicies, {}, 'Choose a Creature with cost 2 or less to reanimate')
            local pI = choice[0]
            if pI ~= playerI then
                -- * shouldn't ever happen
                error('tried to pick card in opponent\'s discard (Raise the Dead)')
                return
            end
            local discardI = choice[1]
            local card = STATE.Players[playerI].DiscardPile[discardI]

            -- TODO? does nothing if can't place creature anywhere, fix?
            if #LandscapesAvailableForCreature(playerI, card) == 0 then
                return
            end
            RemoveFromDiscard(playerI, discardI)

            PlaceCreature(playerI, card, true)
        end
    )

    return result
end