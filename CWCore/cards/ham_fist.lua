-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Target Creature you control has -5 ATK this turn. Draw a card.
    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter():ControlledBy(playerI):Do()
        end,
        'Choose a creature to return to hand',
        function (id, playerI, target)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target.Original.IPID)
                    if c == nil then
                        return
                    end
                    target.Attack = target.Attack - 5
                end
            end)
            Draw(playerI, 1)
        end
    )


    return result
end