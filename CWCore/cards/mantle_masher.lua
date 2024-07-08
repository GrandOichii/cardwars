-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Mantle Masher enters play, flip a Landscape in this Lane face down. When Mantle Masher leaves play, flip it face up.
    CW.Creature.RockNRollerEffect(result)

    return result
end