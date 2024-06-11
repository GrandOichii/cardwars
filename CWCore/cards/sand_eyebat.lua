-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    -- When another Creature enters play under your control, Sand Eyebat gains 1 DEF.
    Common.Triggers.OnAnotherCreatureEnterPlayUnderYourControl(result,
        function (me, ownerI, laneI, args)
            Common.GainDefense(me, 1)
        end
    )

    return result
end