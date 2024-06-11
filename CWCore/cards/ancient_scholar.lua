-- FLOOP >>> Return a random Rainbow card from your Discard Pile to your Hand. If you Control a Building in this Lane, gain 1 Action.

-- Status: not implemented - requires rng

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local discard = STATE.Players[playerI].DiscardPile
            local ids = {}
            for i = 1, discard.Count do
                ids[#ids+1] = discard[i - 1].Original.ID
            end
            -- TODO replace with additional check in activated effect
            if #ids == 0 then
                return
            end
            -- local id = ChooseCardInDiscard(playerI, ids, {}, 'Choose a Rainbow card to place on top of your deck')


            if Common.ControlBuildingInLane(playerI, laneI) then
                AddActionPoints(playerI, 1)
            end
        end
    )

    return result
end