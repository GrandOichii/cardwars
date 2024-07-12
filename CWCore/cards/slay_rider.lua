-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 3 Damage to target Creature on a Landscape with a Frozen token on it.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.AllPlayers.CreaturesWithFrozenTokens(), playerI, me.Original.IPID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.IPID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ipids = CW.IPIDs(Common.TargetableByCreature(Common.AllPlayers.CreaturesWithFrozenTokens(), playerI, me.Original.IPID))
            local target = TargetCreature(playerI, ipids, 'Choose a Creature to deal damage to')
            Common.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, target, 3)
        end
    })

    return result
end