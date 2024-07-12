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
            local ipids = CW.IPIDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))

            local ipid = ChooseCreature(playerI, ipids, 'Choose a creature to deal damage to')
            Common.Damage.ToCreatureBySpell(id, playerI, ipid, amount)
        end
    )

    return result
end