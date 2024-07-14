-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Play your next Creature or Building for free if a Creature or Building with that name is in play.

            CW.Mod.ModNextCostFunc(playerI,
                function (card)
                    return
                        #CW.CreatureFilter():ControlledBy(playerI):Named(card.Original.Template.Name) > 0 or
                        #CW.BuildingFilter():ControlledBy(playerI):Named(card.Original.Template.Name) > 0
                end,
                function (card)
                    CW.Mod.Cost(card, -card.Cost)
                end
            )
        end
    )

    return result
end