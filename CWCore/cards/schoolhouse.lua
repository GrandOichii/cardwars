-- Status: implemented, requires A LOT of testing

function _Create()
    local result = CardWars:InPlay()

    result:AddActivatedEffect({
        text = 'FLOOP >>> Your Creature in this Lane loses all abilities and gains the FLOOP ability of a random Creature (with a FLOOP ability) in your discard pile until end of turn.',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return
                Common.CanFloop(me) and
                #Common.CreaturesInLane(playerI, laneI) == 1
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local creature = Common.CreaturesInLane(playerI, laneI)[1]
            local id = creature.Original.Card.ID

            local abilities = Common.FloopAbilitiesOfCreaturesInDiscard(playerI)
            local a = nil
            if #abilities > 0 then
                local idx = Random(1, #abilities + 1)
                local ability = abilities[idx]
                a = DynamicActivatedEffect(ability)
            end
            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ABILITY_GRANTING_REMOVAL then
                    local c = GetCreatureOrDefault(id)
                    if c == nil then
                        return
                    end

                    -- TODO? isn't clear from the card itself, removes the activated effects or all effects entirely?
                    Common.AbilityGrantingRemoval.RemoveAllActivatedEffects(c)
                    if a == nil then
                        return
                    end
                    c.ActivatedEffects:Add(a)
                end
            end)
        end
    })

    return result
end