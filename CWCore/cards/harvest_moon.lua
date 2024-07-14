-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.LandscapeFilter()
                :NoBuildings()
                :ControlledBy(playerI)
                :Do() == 0
        end
    )

    -- Put a Building from your discard pile into play.
    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'card',
                target = CW.Spell.Target.CardInDiscardPile(
                    function (id, playerI)
                        return CW.CardsInDiscardPileFilter()
                            :Buildings()
                            -- TODO? do frozen tokens prevent placing buildings
                            -- :Custom(function (card)
                            --     return #LandscapesAvailableForBuilding(playerI, card) > 0
                            -- end)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a Building in your discard pile to put into play'
                    end
                )
            },
        },
        function (id, playerI, targets)
            RemoveFromDiscard(playerI, targets.card.idx)

            PlaceBuilding(playerI, targets.card.card, true)
        end
    )
    
    return result
end