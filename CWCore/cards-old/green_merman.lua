-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)
    
    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Put the top card of your deck into your discard pile, Deal Damage to each opposing Creature equal to the discarded card\'s Action Cost.',
        function (me, playerI, laneI)
            local milled = Mill(playerI, 1)
            if #milled == 0 then
                return
            end
            UpdateState()
            local card = milled[1]
            local creatures = Common.OpposingCreatures(playerI)
            for _, creature in ipairs(creatures) do
                DealDamageToCreature(creature.Original.Card.ID, card.Template.Cost)
            end
        end
    )

    return result
end