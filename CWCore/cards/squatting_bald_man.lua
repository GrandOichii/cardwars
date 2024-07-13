-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.DiscardCards(
        result,
        'Discard a card >>> Heal 1 Damage from Squatting Bald Man. (Use any number of times during each of your turns.)',
        1,
        function (me, playerI, laneI)
            HealDamage(me.Original.IPID, 1)
        end
    )

    return result
end