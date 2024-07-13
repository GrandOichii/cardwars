-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'Discard a card >>> Your Creature in this Lane can\'t be targeted or attacked until the start of your next turn.',
        CW.ActivatedAbility.Cost.DiscardFromHand(1),
        function (me, playerI, laneI)
            UntilNextTurn(playerI, function (layer)
                local f = CW.CreatureFilter()
                    :ControlledBy(playerI)
                    :InLane(laneI)

                if layer == CardWars.ModificationLayers.ATTACK_RIGHTS then
                    local creatures = f:Do()
                    for _, creature in ipairs(creatures) do
                        CW.State.CantBeAttacked(creature)
                    end
                end
                if layer == CardWars.ModificationLayers.TARGETING_PERMISSIONS then
                    local creatures = f:Do()
                    for _, creature in ipairs(creatures) do
                        CW.State.CantBeTargeted(creature)
                    end
                end
            end)
        end
    )

    return result
end