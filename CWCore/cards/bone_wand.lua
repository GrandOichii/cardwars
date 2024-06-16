-- Play only if you control a Useless Swamp Creature.

-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil, #Common.CreaturesTyped(playerI, CardWars.Landscapes.UselessSwamp) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Target opponent discards a card from his hand.

            local opponent = Common.TargetOpponent(playerI)
            Common.ChooseAndDiscardCard(opponent)
        end
    )

    return result
end