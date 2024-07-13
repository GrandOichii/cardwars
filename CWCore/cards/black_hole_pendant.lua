-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.Targetable.BySpell(Common.AllPlayers.Creatures(), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target Creature has +X ATK this turn, where X is the number of different Landscape types your opponent controls.
            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.AllPlayers.Creatures(), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to buff')
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