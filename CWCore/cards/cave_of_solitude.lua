-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    Common.ActivatedAbilities.DiscardCard(
        result,
        'Discard a card >>> Your Creature in this Lane can\'t be targeted or attacked until the start of your next turn.',
        function (me, playerI, laneI)
            UntilNextTurn(playerI, function (layer)
                -- * don't need to get a whole array for just 1 creature, but just in case
                if layer == CardWars.ModificationLayers.ATTACK_RIGHTS then
                    local creatures = Common.CreaturesInLane(playerI, laneI)
                    for _, creature in ipairs(creatures) do
                        Common.State.CantBeAttacked(creature)
                    end
                end
                if layer == CardWars.ModificationLayers.TARGETING_PERMISSIONS then
                    local creatures = Common.CreaturesInLane(playerI, laneI)
                    for _, creature in ipairs(creatures) do
                        Common.State.CantBeTargeted(creature)
                    end
                end
            end)
        end
    )

    return result
end