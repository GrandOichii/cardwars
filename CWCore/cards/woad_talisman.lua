-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter()
                :ControlledBy(playerI)
                :LandscapeType(CardWars.Landscapes.BluePlains)
                :Do()
        end,
        'Choose a Blue Plains Creature to buff',
        function (id, playerI, target)
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(target.Original.IPID)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end
    )

    return result
end