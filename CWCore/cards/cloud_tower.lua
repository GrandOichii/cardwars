-- Status: implemented, requires a lot of testing

function _Create()
    local result = CardWars:InPlay()

    result:AddStateModifier(function (me, layer, zone)
        -- Your Creature on this Landscape cannot be targeted by your foe's Spells or Creature abilities.

        if layer == CardWars.ModificationLayers.TARGETING_PERMISSIONS and zone == CardWars.Zones.IN_PLAY then
            local controllerI = me.Original.ControllerI
            local creature = STATE.Players[controllerI].Landscapes[me.LaneI].Creature
            if creature == nil then
                return
            end

            creature.CanBeTargetedCheckers:Add(function (source)
                if source.ownerI == controllerI then
                    return true
                end
                if source.type ~= CardWars.TargetSources.SPELL and source.type ~= CardWars.TargetSources.CREATURE_ABILITY then
                    return true
                end
                return false
            end)
        end

    end)

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move a Creature you control to this Landscape.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return CW.Landscape.IsEmpty(playerI, laneI)
            end),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():ControlledBy(playerI)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            if targets.creature.LaneI == laneI then
                return
            end
            MoveCreature(targets.creature.Original.ipid, laneI)
        end,
        -1
    )

    return result
end