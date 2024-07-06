-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 3 Damage to target Creature on a Landscape with a Frozen token on it.',
        tags = {'floop'},
        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.TargetableByCreature(Common.AllPlayers.CreautresWithFrozenTokens(), playerI, me.Original.Card.ID) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local ids = Common.IDs(Common.TargetableByCreature(Common.AllPlayers.CreautresWithFrozenTokens(), playerI, me.Original.Card.ID))
            local target = TargetCreature(playerI, ids, 'Choose a Creature to deal damage to')
            Common.Damage.ToCreatureByCreatureAbility(me.Original.Card.ID, playerI, target, 3)
        end
    })

    return result
end