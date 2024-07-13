-- Status: implemented, kinda sus code

function _Create()
    local result = CardWars:Creature()
    
    CW.ActivatedAbility.Common.DiscardCards(
        result,
        'Discard a card >>> Dragon Foot has +1 ATK this turn. (Use up to five times during each of your turns.)',
        1,
        function (me, playerI, laneI)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(ipid)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 1
                end
            end)
        end,
        nil,
        5
    )

    return result
end