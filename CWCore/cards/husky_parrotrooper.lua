-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Creature()

    -- When Husky Parrotrooper enters play, move it to any empty Landscape, and then flip that Landscape face down.
    CW.Creature.ParrottrooperEffect(
        result,
        function (me)
            SoftUpdateState()
            local newMe = GetCreature(me.Original.Card.ID)
            CW.Landscape.FlipDown(newMe.Original.ControllerI, newMe.LaneI)
        end
    )

    return result
end