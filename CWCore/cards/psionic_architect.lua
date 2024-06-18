-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result.OnEnterP:AddLayer(function(me, playerI, laneI, replaced)
        -- When Psionic Architect enters play, you may ready a Flooped Creature you control.

        local ids = Common.IDs(Common.FloopedCreatures(playerI))

        if #ids == 0 then
            return
        end

        local creatureId = ChooseCreature(playerI, ids, 'Choose a creature to ready')
        local creature = GetCreature(creatureId)

        local accept = YesNo(playerI, 'Ready '..creature.Original.Card.Template.Name..'?')
        if not accept then
            return
        end

        ReadyCard(creatureId)
    end)

    return result
end
