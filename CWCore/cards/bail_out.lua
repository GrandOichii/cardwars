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
                        return CW.CreatureFilter():OwnedBy(playerI)
                            :Do()
                    end,
                    function (id, playerI, targets)
                        return 'Choose a creature to return to hand and play against'
                    end
                )
            },
        },
        function (id, playerI, targets)
            CW.Bounce.ReturnToHandAndPlayForFree(playerI, targets.creature.Original.IPID)
        end
    )
    
    return result
end