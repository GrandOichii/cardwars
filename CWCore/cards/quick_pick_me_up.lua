-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Return target Creature you control to its owner's hand. Gain Actions equal to its cost.
    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter():ControlledBy(playerI):Do()
        end,
        'Choose a creature to return to hand',
        function (id, playerI, target)
            local cost = target.Original.Card.Template.Cost
            ReturnCreatureToOwnersHand(target.Original.Card.ID)
            AddActionPoints(playerI, cost)
        end
    )

    return result
end