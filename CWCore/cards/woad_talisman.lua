-- Status: Implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- TODO add check - any creatures in play

    result.EffectP:AddLayer(
        function (playerI)
            -- Target Blue Plains Creature you control has +2 ATK this turn.

            local s = GetState()
            local ids = Common.State:CreatureIDs(s, function (creature)
                return
                    creature.Original.OwnerI == playerI and
                    creature.Original.Card.Template.Landscape == 'Blue Plains'
            end)
            local target = TargetCreature(playerI, ids, 'Choose a creature to buff')

            UntilEndOfTurn(function (state)
                local creature = GetCreatureOrDefault(target)
                if creature == nil then
                    return
                end
                creature.Attack = creature.Attack + 2
            end)
        end
    )

    return result
end