-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- !FIXME add cast check

    result.EffectP:AddLayer(
        function (playerI)
            -- Deal 1 Damage to target creature for each Cornfield Landscape you control.

            local amount = #Common:LandscapesTyped(playerI, CardWars.Landscapes.Cornfield)

            local creatureIds = Common:IDs(Common.AllPlayers:Creatures())
            -- TODO remove
            if #creatureIds == 0 then
                return
            end
            local creatureId = ChooseCreature(playerI, creatureIds, 'Choose a creature to deal damage to')

            DealDamageToCreature(creatureId, amount)
        end
    )

    return result
end