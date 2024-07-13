-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Sea Hag has +1 ATK while attacking a Creature that is on a Useless Swamp Landscape.
    CW.State.WhileAttackingCreature(
        result,
        function (defender)
            return STATE.Players[defender.Original.ControllerI].Landscapes[defender.LaneI]:Is(CardWars.Landscapes.UselessSwamp)
        end,
        function (me)
            me.Attack = me.Attack + 1
        end
    )

    return result
end