-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When a Creature you own leaves play, you may put it underneath this card instead. + 1 ATK and + 1 DEF for each card under this. When this card leaves play, discard all cards under it.
    -- TODO pretty complicated

    return result
end