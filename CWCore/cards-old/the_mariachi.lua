-- Status: not implemented

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 1 Damage to target Creature for each Creature that entered play this turn.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.Targetable(playerI, Common.AllPlayers.Creatures()) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local amount = 0
            for i = 0, 1 do
                local p = STATE.Players[i]
                for ii = 0, p.Landscapes.Count - 1 do
                    local l = p.Landscapes[ii]
                    amount = amount + l.Original.CreaturesEnteredThisTurn.Count
                end
            end

            local ids = CW.IDs(Common.Targetable(playerI, Common.AllPlayers.Creatures()))
            local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
            DealDamageToCreature(target, amount)
        end
    })

    return result
end