-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.Floop(
        result,
        'FLOOP >>> Put the top card of your deck into your discard pile, Deal Damage to each opposing Creature equal to the discarded card\'s Action Cost.',
        function (me, playerI, laneI)
            local milled = Mill(playerI, 1)
            if #milled == 0 then
                return
            end
            UpdateState()
            local card = milled[1]

            local creatures = CW.CreatureFilter()
                :OpposingTo(playerI)
                :Do()
            for _, creature in ipairs(creatures) do
                CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, creature.Original.IPID, card.Template.Cost)
            end
        end
    )

    return result
end