-- When Static Parrotrooper enters play, move it to any empty Landscape. It cannot be replaced. At the start of your turn, deal 1 damage to your Hero.
-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- When Static Parrotrooper enters play, move it to any empty Landscape.  ...
    -- TODO
    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When  enters play, 

        local landscapes = Common.AllPlayers.LandscapesWithoutCreatures()
        local myLanes = {}
        local opponentsLanes = {}
        for _, landscape in ipairs(landscapes) do
            if landscape.Original.OwnerI == playerI then
                myLanes[#myLanes+1] = landscape
            else
                opponentsLanes[#opponentsLanes+1] = landscape
            end
        end
        local lane = ChooseLandscape(playerI, Common.Lanes(myLanes), Common.Lanes(opponentsLanes), 'Choose a landscape to move '..me.Original.Card.Template.Name..' to')
        local toPlayerI = lane[0]
        local toLaneI = lane[1]
        if toPlayerI == playerI then
            MoveCreature(me.Original.Card.ID, toLaneI)
            return
        end
        StealCreature(playerI, me.Original.Card.ID, toLaneI)
    end)

    result:AddStateModifier(function (me, layer, zone)
        -- ... It cannot be replaced. ...

        if layer == CardWars.ModificationLayers.REPLACE_PRIVILEGES and zone == CardWars.Zones.IN_PLAY then
            me.CanBeReplaced = false
        end
    end)

    Common.Triggers.AtTheStartOfYourTurn(result, function (me, controllerI, laneI, args)
        -- ... At the start of your turn, deal 1 damage to your Hero.
        DealDamageToPlayer(controllerI, 1)
    end)

    return result
end