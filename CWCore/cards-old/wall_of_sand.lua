-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- If one or more other SandyLand Creatures enter play during you turn, Wall of Sand has +2 ATK this turn.
    Common.State.ModATKDEF(result, function (me)
        -- TODO? the "enter play during your turn" kinda scares me
        local controllerI = me.Original.ControllerI
        local id = me.Original.Card.ID
        local creatures = Common.CreaturesTypedExcept(controllerI, CardWars.Landscapes.SandyLands, id)
        if #creatures > 0 then
            me.Attack = me.Attack + 2
        end
    end)

    return result
end