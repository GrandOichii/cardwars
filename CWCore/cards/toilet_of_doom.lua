-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.AddRestriction(result,
        function (id, playerI)
            return nil, #CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target Creature you control has +1 ATK this turn for every 5 cards in your discard pile.

            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to buff')
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target)
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