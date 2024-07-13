-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    -- Ghost has +2 ATK while defending against a Creature that is on a SandyLands Landscape.
    CW.State.WhileDefendingAgainst(
        result,
        function (against)
            return STATE.Players[against.Original.ControllerI].Landscapes[against.LaneI]:Is(CardWars.Landscapes.SandyLands)
        end,
        function (me)
            me.Attack = me.Attack + 2
        end
    )

    return result
end