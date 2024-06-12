-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.AllPlayers.Creatures() > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Deal 1 Damage to target creature for each Cornfield Landscape you control.

            local amount = #Common.LandscapesTyped(playerI, CardWars.Landscapes.Cornfield)
            local creatureIds = Common.IDs(Common.AllPlayers.Creatures())

            local creatureId = ChooseCreature(playerI, creatureIds, 'Choose a creature to deal damage to')
            DealDamageToCreature(creatureId, amount)
        end
    )

    return result
end