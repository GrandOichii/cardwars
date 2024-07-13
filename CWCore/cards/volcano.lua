-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'building',
                target = CW.Spell.Target.Building(
                    function (id, playerI)
                        return CW.BuildingFilter():Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature Building to destroy'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Destroy target Building. You may deal 3 Damage to a Creature in that Lane. Flip your Landscape in that Lane face down.
            local building = targets.building
            local bipid = building.Original.IPID
            local laneI = building.LaneI

            DestroyBuilding(bipid)
            UpdateState()

            local f = CW.CreatureFilter()
                :InLane(laneI)
            local creatureIPIDs = CW.IPIDs(CW.Targetable.BySpell(f:Do(), playerI, id))
            if #creatureIPIDs > 0 then
                local creature = TargetCreature(playerI, creatureIPIDs, '')
                local c = GetCreature(creature)
                local accept = YesNo(playerI, 'Deal 3 damage to '..c.Original.Card.Template.Name..'?')
                if accept then
                    CW.Damage.ToCreatureBySpell(id, playerI, creature, 3)
                end
            end

            CW.Landscape.FlipDown(playerI, laneI)
        end
    )

    return result
end