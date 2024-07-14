-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'Discard Sand Castle from play >>> Put your Creature on this Landscape into your hand and then play it for free.',
        CW.ActivatedAbility.Cost.DiscardSelfFromPlay(),
        function (me, playerI, laneI, targets)
            local creature = CW.CreatureFilter()
                :ControlledBy(playerI)
                :InLane(laneI)
                :Do()[1]
            if creature == nil then
                return
            end
            -- checks if the creature is not stolen, if it is, doesn't execute the ability
            if creature.Original.ControllerI ~= creature.Original.Card.OwnerI then
                return
            end
            CW.Bounce.ReturnToHandAndPlayForFree(playerI, creature.Original.IPID)
        end,
        -1
    )

    return result
end