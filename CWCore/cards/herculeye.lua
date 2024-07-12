-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.DiscardCard(result,
        'Discard a card >>> Herculeye has +4 ATK this turn. (Use only once during each of your turns.)',
        function (me, playerI, laneI)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF  then
                    local creature = GetCreatureOrDefault(ipid)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 4
                end
            end)
        end, 1
    )

    return result
end