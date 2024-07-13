-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Play only if you control a Useless Swamp Creature.
    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.CreatureFilter()
                :ControlledBy(playerI)
                :LandscapeType(CardWars.Landscapes.UselessSwamp)
                :Do() > 0
        end
    )

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'opponentIdx',
                target = CW.Spell.Target.Opponent()
            }
        },
        function (id, playerI, targets)
            -- Target opponent discards a card from his hand.

            CW.Discard.ACard(targets.opponentIdx)
        end

    )

    return result
end