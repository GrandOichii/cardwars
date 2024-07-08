-- Status: implemented, CW

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(result,
        'FLOOP >>> Draw a card for each Flooped Creature you control (including this one).',
        function (me, playerI, laneI)
            local creatures = CW.CreatureFilter()
                :ControlledBy(playerI)
                :Flooped()
                :Do()
            Draw(playerI, #creatures)
        end
    )

    return result
end