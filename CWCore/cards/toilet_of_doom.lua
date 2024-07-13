-- Status: not tested

function _Create()
    local result = CardWars:Spell()
    
    CW.SpellTargetCreature(
        result,
        function (id, playerI)
            return CW.CreatureFilter()
                :ControlledBy(playerI)
                :Do()
        end,
        'Choose a Creature to buff',
        function (id, playerI, creature)
            local ipid = creature.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(ipid)
                    if c == nil then
                        return
                    end
                    local count = GetPlayer(playerI).DiscardPile.Count
                    if count == 0 then
                        return
                    end
                    c.Attack = c.Attack + math.floor(count / 5)
                end
            end)
        end
    )

    return result
end