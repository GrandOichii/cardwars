-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Destroy target creature
            
            local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
            local target = TargetCreature(playerI, ids, 'Choose a creature to destroy')
            DestroyCreature(target)
        end
    )

    return result
end