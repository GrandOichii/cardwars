-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Freeze both Landscapes in this Lane. Use only if no Frozen tokens are in play.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #CW.LandscapeFilter():IsFrozen():Do() == 0
            end),
            CW.ActivatedAbility.Cost.Floop()
        ),
        function (me, playerI, laneI, targets)
            local landscapes = CW.LandscapeFilter():OnLane(laneI):Do()

            for _, landscape in ipairs(landscapes) do
                CW.Freeze.Landscape(landscape.Original.OwnerI, landscape.Original.Idx)
            end
        end,
        -1
    )

    return result
end