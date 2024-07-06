-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Creatures on Landscapes with a Frozen token on it have -1 ATK.
    Common.State.ModATKDEF(result, function (me)
        local creatures = Common.AllPlayers.CreautresWithFrozenTokens()
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack - 1
        end
    end)

    return result
end