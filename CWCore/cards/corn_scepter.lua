-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    -- Deal 1 Damage to target creature for each Cornfield Landscape you control.
    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter():Do()
        end,
        'Choose a creature to deal damage to',
        function (id, playerI, target)
            local amount = CW.Count.LandscapesOfType(CardWars.Landscapes.Cornfield, playerI)

            CW.Damage.ToCreatureBySpell(id, playerI, target.Original.IPID, amount)
        end
    )

    return result
end