-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.AllPlayers.Buildings(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Destroy target Building. You may deal 3 Damage to a Creature in that Lane. Flip your Landscape in that Lane face down.
            local ids = Common.IDs(Common.TargetableBySpell(Common.AllPlayers.Buildings(), playerI, id))
            local target = TargetBuilding(playerI, ids, 'Choose a creature to destroy')
            local building = GetBuilding(target)
            local laneI = building.LaneI

            DestroyBuilding(target)
            UpdateState()
            local creatureIDs = Common.IDs(Common.TargetableBySpell(Common.AllPlayers.CreaturesInLane(laneI), playerI, id))
            if #creatureIDs > 0 then
                local creature = TargetCreature(playerI, creatureIDs, '')
                local c = GetCreature(creature)
                local accept = YesNo(playerI, 'Deal 3 damage to '..c.Original.Card.Template.Name..'?')
                if accept then
                    Common.Damage.ToCreatureBySpell(id, playerI, creature, 3)
                end
            end

            TurnLandscapeFaceDown(playerI, laneI)
        end
    )

    return result
end