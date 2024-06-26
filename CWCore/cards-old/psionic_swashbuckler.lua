-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    result.OnEnterP:AddLayer(function(playerI, laneI, replaced)
        -- When Psionic Swashbuckler enters play, you may deal 3 Damage to target Flooped Creature

        local ids = Common.IDs(Common.Targetable(playerI, Common.AllPlayers.FloopedCreatures()))
        if #ids == 0 then
            return
        end
        local target = TargetCreature(playerI, ids, 'Choose a creature to deal damage to')
        local creature = GetCreature(target)
        local accept = YesNo(playerI, 'Deal 3 Damage to '..creature.Original.Card.Template.Name..'?')
        if not accept then
            return
        end
        DealDamageToCreature(target, 3)
    end)

    return result
end