-- Status: implemented

function _Create()
    local result = CardWars:Hero()

    result:AddActivatedAbility({
        text = 'Discard a card from you hand >>> Deal 1 Damage to target Creature.',
        tags = {'floop'},

        maxActivationsPerTurn = -1,
        checkF = function (playerI)
            return
                GetHandCount(playerI) > 0 and
                #CW.Targetable.ByHero(Common.AllPlayers.Creatures(), playerI) > 0
        end,
        costF = function (playerI)
            CW.Discard.ACard(playerI)
            return true
        end,
        effectF = function (playerI)
            local ipids = CW.IPIDs(CW.Targetable.ByHero(Common.AllPlayers.Creatures(), playerI))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to deal damage to')
            CW.Damage.ToCreatureByHero(playerI, target, 1)
        end
    })

    return result
end