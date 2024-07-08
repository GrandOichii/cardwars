-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Rock 'n Roller enters play, flip a Landscape in this Lane face down. When Rock 'n Roller leaves play, flip it face up.
    CW.Creature.RockNRollerEffect(result)

    return result
end