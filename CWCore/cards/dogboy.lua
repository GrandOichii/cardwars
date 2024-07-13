-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.DiscardCards(
        result,
        'Discard a card >>> Dogboy has +2 ATK this turn. (Use only once during each of your turns.)',
        1,
        function (me, playerI, laneI)
            local ipid = me.Original.IPID
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(ipid)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack + 2
                end
            end)
        end,
        nil,
        1
    )

    return result
end