-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.Targetable.BySpell(Common.AllPlayers.Buildings(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Destroy target Building. You may deal 3 Damage to a Creature in that Lane. Flip your Landscape in that Lane face down.
            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.AllPlayers.Buildings(), playerI, id))
            local target = TargetBuilding(playerI, ipids, 'Choose a creature to destroy')
            local building = GetBuilding(target)
            local laneI = building.LaneI

            DestroyBuilding(target)
            UpdateState()
            local creatureIPIDs = CW.IPIDs(CW.Targetable.BySpell(Common.AllPlayers.CreaturesInLane(laneI), playerI, id))
            if #creatureIPIDs > 0 then
                local creature = TargetCreature(playerI, creatureIPIDs, '')
                local c = GetCreature(creature)
                local accept = YesNo(playerI, 'Deal 3 damage to '..c.Original.Card.Template.Name..'?')
                if accept then
                    CW.Damage.ToCreatureBySpell(id, playerI, creature, 3)
                end
            end

            TurnLandscapeFaceDown(playerI, laneI)
        end
    )

    return result
end