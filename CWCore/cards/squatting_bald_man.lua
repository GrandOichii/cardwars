-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DiscardCard(
        result,
        'Discard a card >>> Heal 1 Damage from Squatting Bald Man. (Use any number of times during each of your turns.)',
        function (me, playerI, laneI)
            HealDamage(me.Original.Card.ID, 1)
        end
    )

    return result
end