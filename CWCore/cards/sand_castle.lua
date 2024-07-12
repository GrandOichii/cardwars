-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    Common.ActivatedAbilities.DiscardFromPlay(
        result,
        'Discard Sand Castle from play >>> Put your Creature on this Landscape into your hand and then play it for free.',
        function (me, playerI, laneI)
            local creature = Common.CreaturesInLane(playerI, laneI)[1]
            if creature == nil then
                return
            end
            -- checks if the creature is not stolen, if it is, doesn't execute the ability
            if creature.Original.ControllerI ~= creature.Original.Card.OwnerI then
                return
            end
            Common.Bounce.ReturnToHandAndPlayForFree(playerI, creature.Original.IPID)
        end
    )

    return result
end