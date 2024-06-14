-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result,
        function (playerI)
            return nil, #playerI, Common.AllPlayers.Creatures() > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Destroy target creature
            
            local ids = Common.IDs(Common.AllPlayers.Creatures())
            local target = TargetCreature(playerI, ids, 'Choose a creature to destroy')
            DestroyCreature(target)
        end
    )

    return result
end