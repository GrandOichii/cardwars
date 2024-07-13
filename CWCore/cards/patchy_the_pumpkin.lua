-- Status: implemented, could use some more testing

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Deal 1 Damage to target Creature. Do this once for each Cornfield Landscape you control. (May only target each Creature once.)',
        CW.ActivatedAbility.Cost.Floop(),
        function (me, playerI, laneI)

            local count = #CW.LandscapeFilter()
                :ControlledBy(playerI)
                :OfLandscapeType(CardWars.Landscapes.Cornfield)
                :Do()

            local myIPID = me.Original.IPID

            -- TODO this feels like this should only target opposing creatures
            local ipids = CW.IPIDs(CW.Targetable.ByCreature(CW.CreatureFilter()
                :Do()
            , playerI, myIPID))

            for i = 1, count do
                if #ipids == 0 then
                    return
                end

                local target = TargetCreature(playerI, ipids, 'Choose a creature to deal damage to')
                CW.Damage.ToCreatureByCreatureAbility(myIPID, playerI, target, 1)

                local newOptions = {}
                for _, option in ipairs(ipids) do
                    if option ~= target then
                        newOptions[#newOptions+1] = option
                    end
                end

                ipids = newOptions
                UpdateState()
            end

        end
    )

    return result
end