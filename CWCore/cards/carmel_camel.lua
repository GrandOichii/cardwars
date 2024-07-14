-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When a Creature you own leaves play, you may put it underneath this card instead.
    -- TODO pretty complicated
    -- ! this also intervenes with some cards' effects
    -- ! example: Bail Out returns creature to hand and forces the player to play it for free. If the player chooses to put the bounced card underneath Carmel Camel, they will no longer be able to play it for free, causing a crash (i think)

    -- + 1 ATK and + 1 DEF for each card under this.

    -- When this card leaves play, discard all cards under it.

    return result
end