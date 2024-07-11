-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Psionic Architect enters play, you may ready a Flooped Creature you control.

        local creature = CW.Choose.Creature(playerI, CW.CreatureFilter():ControlledBy(playerI):Flooped():Do(), 'Choose a Flooped Creature to ready')
        if creature == nil then
            return
        end

        local accept = YesNo(playerI, 'Ready '..creature.Original.Card.Template.Name..'?')
        if not accept then
            return
        end

        ReadyCard(creature.Original.Card.ID)
    end)

    return result
end
