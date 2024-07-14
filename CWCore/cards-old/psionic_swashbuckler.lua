-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result:OnEnter(function(me, playerI, laneI, replaced)
        -- When Psionic Swashbuckler enters play, you may deal 3 Damage to target Flooped Creature

        local ids = CW.IDs(Common.Targetable(playerI, Common.AllPlayers.FloopedCreatures()))
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