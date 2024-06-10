-- Status: implemented, could use some more testing

function _Create(props)
    local result = CardWars:Creature(props)
    
    result:AddActivatedEffect({
        -- FLOOP >>> Deal 1 Damage to target Creature. Do this once for each Cornfield Landscape you control. (May only target each Creature once.)

        checkF = function (me, playerI, laneI)
            return Common:CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local lanes = STATE.Players[playerI].Landscapes
            local count = 0
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane:Is('Cornfield') then
                    count = count + 1
                end
            end

            local options = Common:IDs(Common:FilterCreatures( function (creature)
                -- TODO? not implicitly said, but without this Patchy will be forced to deal damage to itself
                return creature.Original.OwnerI ~= playerI
            end))

            for i = 1, count do
                if #options == 0 then
                    return
                end

                local target = TargetCreature(playerI, options, 'Choose a creature to deal damage to')
                DealDamageToCreature(target, 1)

                local newOptions = {}
                for _, option in ipairs(options) do
                    if option ~= target then
                        newOptions[#newOptions+1] = option
                    end
                end

                options = newOptions
            end
        end
    })

    return result
end