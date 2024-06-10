-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    result.EffectP:AddLayer(
        function (playerI)
            -- Deal 1 Damage to target creature for each Cornfield Landscape you control.

            local state = GetState()
            local lanes = state.Players[playerI].Landscapes
            local amount = 0
            for i = 1, lanes.Count do
                local lane = lanes[i - 1]
                if lane:Is('Cornfield') then
                    amount = amount + 1
                end
            end

            local creatureIds = Common.State:CreatureIDs(state, function () return true end)
            local creatureId = ChooseCreature(playerI, creatureIds, 'Choose a creature to deal damage to')

            DealDamageToCreature(creatureId, amount)
        end
    )

    return result
end