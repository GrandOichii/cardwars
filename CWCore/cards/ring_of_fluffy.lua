-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter():ControlledBy(playerI):Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to buff'
                    end
                )
            }
        },
        function (id, playerI, targets)
            -- Target Creature you control has +X ATK this turn, where X is the amount of Damage on it.

            local ipid = targets.creature.Original.IPIDs
            UntilEndOfTurn(function ( layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(ipid)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + creature.Original.Damage
                end
            end)
        end
    )

    return result
end