-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    local filter = function (playerI, laneI)
        return CW.CreatureFilter():ControlledBy(playerI):InLane(laneI):Do()
    end

    -- TODO not clear with the new card that will be able to stand in the same landscape as another creature
    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Your Creature in this Lane loses all abilities and gains the FLOOP ability of a random Creature (with a FLOOP ability) in your discard pile until end of turn.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(
                function (me, playerI, laneI)
                    return #filter(playerI, laneI) > 0
                end
            )
        ),
        function (me, playerI, laneI)
            local creature = filter(playerI, laneI)[1]
            local ipid = creature.Original.IPID

            local abilities = Common.FloopAbilitiesOfCreaturesInDiscard(playerI)
            local a = nil
            if #abilities > 0 then
                local idx = Random(1, #abilities + 1)
                local ability = abilities[idx]
                a = DynamicActivatedAbility(ability)
            end
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end

                    CW.AbilityGrantingRemoval.RemovaAllFromCreature(c)
                    if a == nil then
                        return
                    end
                    c.ActivatedAbilities:Add(a)
                end
            end)
        end
    )

    return result
end