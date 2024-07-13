-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Reveal a card from your hand. That card becomes a Rainbow card until the end of your turn. (It has no Landscape type).',
        function (me, playerI, laneI)
            local cards = STATE.Players[playerI].Hand
            if cards.Count == 0 then
                return nil
            end
        
            local ids = {}
            for i = 1, cards.Count do
                ids[#ids+1] = i - 1
            end
            
            local cardI = ChooseCardInHand(playerI, ids, 'Choose a card to reveal (It will become a Rainbow card until end of turn)')
            RevealCardFromHand(playerI, cardI)
            local id = cards[cardI].Original.ID
            UntilEndOfTurn(function (layer)
                CW.State.ChangeLandscapeType(layer, id, CardWars.Landscapes.Rainbow)
            end)
        end
    )



    return result
end