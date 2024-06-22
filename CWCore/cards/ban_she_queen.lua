-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    result.OnEnterP:AddLayer(function(me, playerI, laneI, replaced)
        -- When Ban-She Queen enters play, you may remove a token from an adjacent Landscape.

        local landscapes = Common.AdjacentLandscapes(playerI, laneI)
        local choices = {}
        for _, landscape in ipairs(landscapes) do
            if landscape.Original.Tokens.Count > 0 then
                choices[#choices+1] = landscape.Original.Idx
            end
        end
        if #choices == 0 then
            return
        end

        -- TODO add choice instead, kinda clunky
        local choice = ChooseLandscape(playerI, choices, {}, 'Choose a landscape to remove a token from')
        local idx = choice[1]
        local removeFrom = STATE.Players[playerI].Landscapes[idx]
        local tokens = removeFrom.Original.Tokens
        for i = 0, tokens.Count - 1 do
            local remove = YesNo(playerI, 'Remove '..tokens[i]..' token?')
            if remove then
                RemoveToken(playerI, idx, tokens[i])
                return
            end
        end

    end)

    return result
end