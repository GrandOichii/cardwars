-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- TODO not specified in the rules, but during testing this leads to an infinite loop
    local targets = function (me, playerI)
        local id = me.Original.Card.ID
        return Common.TargetableByBuilding(Common.AllPlayers.CreaturesExcept(id), playerI, id)
    end

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 1 Damage to target Creature. If Cottonpult has 5 or more Damage on it, it heals 1 Damage and readies.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #targets(me, playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(targets(me, playerI))
            local target = TargetCreature(playerI, ids, 'Choose creature to damage')

            local myID = me.Original.Card.ID
            Common.Damage.ToCreatureByCreatureAbility(myID, target, 1)
            if me.Original.Damage >= 5 then
                HealDamage(myID, 1)
                ReadyCard(myID)
            end
        end
    })

    return result
end