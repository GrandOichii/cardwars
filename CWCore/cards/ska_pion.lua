-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- Ska-pion costs 1 less to play while an opponent controls a Creature you own.
    Common.State.ModCostInHand(result, function (me)
        local pI = me.Original.ControllerI
        local amount = #CW.CreatureFilter():OwnedBy(pI):NotControlledBy(pI):Do()
        if amount == 0 then
            return
        end
        Common.Mod.Cost(me, -1)
    end)

    return result
end