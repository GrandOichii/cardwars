-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.State.ModATKDEF(result, function (me)
        local creatures = Common.CreaturesTyped(me.OwnerI, CardWars.Landscapes.Rainbow)
        for _, creature in ipairs(creatures) do
            creature.Attack = creature.Attack + 1
        end
    end)

    return result
end