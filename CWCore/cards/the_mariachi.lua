-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local calcDamage = function ()
        -- TODO move to common
        local damage = 0
        for i = 0, 1 do
            local p = STATE.Players[i]
            for ii = 0, p.Landscapes.Count - 1 do
                local l = p.Landscapes[ii]
                damage = damage + l.Original.CreaturesEnteredThisTurn.Count
            end
        end
        return damage
    end

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Deal 1 Damage to target Creature for each Creature that entered play this turn.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to deal'..calcDamage()..'Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local amount = calcDamage()
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, targets.creature.Original.IPID, amount)
        end
    )

    return result
end