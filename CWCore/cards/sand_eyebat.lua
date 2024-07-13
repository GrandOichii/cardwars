-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When another Creature enters play under your control, Sand Eyebat gains 1 DEF.
    CW.Triggers.OnAnotherCreatureEnterPlayUnderYourControl(result,
        function (me, controllerI, laneI, args)
            Common.GainDefense(me, 1)
        end
    )

    return result
end