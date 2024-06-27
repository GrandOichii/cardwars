-- Status: implemented, requires testing

function _Create()
    local result = CardWars:Spell()

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Play your next Creature or Building for free if a Creature or Building with that name is in play.

            Common.Mod.ModNextCostFunc(playerI,
                function (card)
                    local cards = Common.InPlay(playerI)
                    for _, c in ipairs(cards) do
                        if c.Original.Card.Template.Name == card.Original.Template.Name then
                            return true
                        end
                    end
                    return false
                end,
                function (card)
                    Common.Mod.Cost(card, -card.Cost)
                end
            )
        end
    )

    return result
end