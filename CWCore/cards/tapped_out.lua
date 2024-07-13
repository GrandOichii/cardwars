-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter():ControlledBy(playerI)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to buff'
                    end
                )
            },
        },
        function (id, playerI, targets)
            local amount = #CW.CreatureFilter()
                :ControlledBy(playerI)
                :Exhausted()
                :Do()

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(targets.creature.Original.IPID)
                    if c == nil then
                        return
                    end
                    c.Attack = c.Attack + amount * 2
                end
            end)
        end
    )

    return result
end