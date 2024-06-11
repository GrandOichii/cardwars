-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result:AddTrigger({
        -- At the start of you turn, you may return Ms. Mummy to its owner's hand. If you do, target SandyLands Creature you control gains 1 DEF.",

        trigger = CardWars.Triggers.TURN_START,
        checkF = function (me, ownerI, laneI)
            return GetCurPlayerI() == ownerI
        end,
        costF = function (me, ownerI, laneI)
            local accept = YesNo(ownerI, 'Return Ms.Mummy to its owner\'s hand?')
            if not accept then
                return false
            end
            ReturnCreatureToOwnersHand(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, ownerI, laneI)
            -- TODO? should this be in check
            local creatures = Common.IDs(Common.CreaturesTyped(ownerI, CardWars.Landscapes.SandyLands))
            if #creatures == 0 then
                return
            end

            local target = TargetCreature(ownerI, creatures, 'Choose a creature to buff')
            local creature = GetCreature(target)

            Common.GainDefense(creature, 1)
        end
    })

    return result
end