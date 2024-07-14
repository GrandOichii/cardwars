-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Destroy a Creature you control, FLOOP >>> Draw a card.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.SacrificeACreature(
                function (me, playerI, laneI)
                    return CW.CreatureFilter()
                end
            ),
            CW.ActivatedAbility.Cost.Floop()
        ),
        function (me, playerI, laneI, targets)
            Draw(playerI, 1)
        end,
        -1
    )

    return result
end