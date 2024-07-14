-- Business Dog has +2 ATK this turn for each card you have played \"Dog\" or \"Puppy\" in its tile this turn.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- TODO tile?

    return result
end