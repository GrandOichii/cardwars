-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Target Creature you control has +2 ATK this turn for each Spell you played this turn (including this one).
    CW.Spell.AddEffect(
        result,
        {
            {
                key = 'creature',
                target = CW.Spell.Target.Creature(
                    function (id, playerI)
                        return CW.CreatureFilter()
                            :ControlledBy(playerI)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to buff'
                    end
                )
            }
        },
        function (id, playerI, targets)
            local ipid = targets.creature.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    local count = #CW.CardsPlayedThisTurnFilter(playerI):Spells():Do()
                    c.Attack = c.Attack + count * 2
                end
            end)
        end
    )

    return result
end