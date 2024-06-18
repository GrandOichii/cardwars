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

    -- FLOOP >>> Move a Creature you control to this Landscape.
    result:AddActivatedAbility({
        text = 'FLOOP >>> Move a Creature you control to this Landscape.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                STATE.Players[playerI].Landscapes[laneI].Creature == nil and
                -- TODO? targetable
                #Common.Creatures(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local creatures = Common.IDs(Common.Creatures(playerI))
            local creatureId = ChooseCreature(playerI, creatures, 'Choose a creature to move')
            local creature = GetCreature(creatureId)
            if creature.LaneI == laneI then
                return
            end
            MoveCreature(creatureId, laneI)
        end
    })

    return result
end