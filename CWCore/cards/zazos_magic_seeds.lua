-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (id, playerI)
            return nil, #Common.TargetableBySpell(Common.AllPlayers.CreaturesTyped(CardWars.Landscapes.SandyLands), playerI, id) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Target SandyLands Creature has +2 ATK this turn for each Creature that entered play into an adjacent Lane this turn.
            local ids = Common.IDs(Common.TargetableBySpell(Common.AllPlayers.CreaturesTyped(CardWars.Landscapes.SandyLands), playerI, id))

            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local c = GetCreatureOrDefault(target)
                    if c == nil then
                        return
                    end
                    local adjacent = Common.AdjacentLandscapes(playerI, c.LaneI)
                    local amount = 0
                    for _, landscape in ipairs(adjacent) do
                        amount = amount + landscape.Original.CreaturesEnteredThisTurn.Count
                    end

                    c.Attack = c.Attack + amount * 2
                end
            end)
        end
    )

    return result
end