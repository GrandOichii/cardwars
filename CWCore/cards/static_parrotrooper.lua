-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Creature()

    -- When Static Parrotrooper enters play, move it to any empty Landscape. It cannot be replaced. 
    CW.Creature.ParrottrooperEffect(result)

    CW.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        -- ... At the start of your turn, deal 1 damage to your Hero.
        DealDamageToPlayer(controllerI, 1)
    end)

    return result
end