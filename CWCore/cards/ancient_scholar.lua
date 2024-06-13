-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Return a random Rainbow card from your Discard Pile to your Hand. If you Control a Building in this Lane, gain 1 Action.',
        function (me, playerI, laneI)
            local idx = Common.RandomCardInDiscard(playerI, function (card)
                return card.Original.Template.Landscape == CardWars.Landscapes.Rainbow
            end)
            if idx ~= nil then
                ReturnToHandFromDiscard(playerI, idx)
            end

            if Common.ControlBuildingInLane(playerI, laneI) then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end