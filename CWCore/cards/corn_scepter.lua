-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Deal 1 Damage to target creature for each Cornfield Landscape you control.

            local amount = Common.CountLandscapesTyped(playerI, CardWars.Landscapes.Cornfield)
            local creatureIds = CW.IDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))

            local creatureId = ChooseCreature(playerI, creatureIds, 'Choose a creature to deal damage to')
            Common.Damage.ToCreatureBySpell(id, playerI, creatureId, amount)
        end
    )

    return result
end