-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Return target Creature you own to your hand.
    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter():OwnedBy(playerI):Do()
        end,
        'Choose a creature to return to hand',
        function (id, playerI, target)
            ReturnCreatureToOwnersHand(target.Original.Card.ID)
        end
    )


    return result
end