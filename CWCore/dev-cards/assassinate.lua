-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter():Do()
        end,
        'Choose a Creature to Destroy',
        function (id, playerI, target)
            DestroyCreature(target.Original.IPID)
        end
    )

    return result
end