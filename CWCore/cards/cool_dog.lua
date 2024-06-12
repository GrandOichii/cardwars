-- Status: not tested, requires further testing

function _Create(props)
    local result = CardWars:Creature(props)

    -- Your Creatures on adjacent Lanes may not be Attacked.
    Common.State.ModAttackRight(result, function (me)
        local ownerI = me.Original.OwnerI
        local id = me.Original.Card.ID
        local opponentI = 1 - ownerI
        local opponent = STATE.Players[opponentI]
        local landscapes = Common.AdjacentCreatures(ownerI, me.LaneI)
        local lanes = opponent.Landscapes
        for _, creature in ipairs(landscapes) do
            local laneI = creature.LaneI
            if lanes[laneI].Creature ~= nil then
                lanes[laneI].Creature.CanAttack = false
            end
        end

    end)

    return result
end