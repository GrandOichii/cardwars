-- Status: not tested

function _Create(props)
    local result = CardWars:Spell(props)
    
    Common.AddRestriction(result,
    function (playerI)
        return nil, #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end
    )
    
    -- Target Creature has +X ATK this turn, where X is the number of different Landscape types your opponent controls.
    result.EffectP:AddLayer(
        function (playerI)
            -- 
            local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')
            -- TODO not clear - at the time of playing or dynamic
            local amount = #GetUniqueLandscapeNames(1 - playerI)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target)
                    if c == nil then
                        return
                    end
                    c.Attack = c.Attack + amount
                end
            end)
        end
    )

    return result
end