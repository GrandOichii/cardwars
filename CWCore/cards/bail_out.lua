-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    Common.AddRestriction(result,
    function (id, playerI)
        return nil, #Common.OwnedCreatures(playerI) > 0
    end
)

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Put target Creature you own into your hand, and then play it for free.
            local ids = Common.IDs(Common.TargetableBySpell(Common.OwnedCreatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose a creature you own to return to your hand and them play for free')

            print(target)
            ReturnCreatureToOwnersHand(target)
            UpdateState()

            local idx = Common.HandCardIdx(playerI, target)
            local card = STATE.Players[playerI].Hand[idx]

            PlayCardIfPossible(playerI, card.Original, true)
        end
    )

    return result
end