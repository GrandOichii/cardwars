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
            -- Destroy target creature
            
            local ids = CW.IPIDs(Common.TargetableBySpell(Common.AllPlayers.Creatures(), playerI, id))
            local target = TargetCreature(playerI, ids, 'Choose a creature to destroy')
            DestroyCreature(target)
        end
    )

    return result
end