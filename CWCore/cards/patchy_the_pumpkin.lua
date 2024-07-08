-- Status: implemented, could use some more testing

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Deal 1 Damage to target Creature. Do this once for each Cornfield Landscape you control. (May only target each Creature once.)',
        tags = {'floop'},

        checkF = function (me, playerI, laneI)
            return Common.CanFloop(me)
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = function (me, playerI, laneI)
            local count = Common.CountLandscapesTyped(playerI, CardWars.Landscapes.Cornfield)
            local myID = me.Original.Card.ID

            local options = CW.IDs(Common.TargetableByCreature(Common.Creatures(1 - playerI), playerI, myID))

            for i = 1, count do
                if #options == 0 then
                    return
                end

                local target = TargetCreature(playerI, options, 'Choose a creature to deal damage to')
                Common.Damage.ToCreatureByCreatureAbility(myID, playerI, target, 1)

                local newOptions = {}
                for _, option in ipairs(options) do
                    if option ~= target then
                        newOptions[#newOptions+1] = option
                    end
                end

                options = newOptions
                UpdateState()
            end
        end
    })

    return result
end