Util = {}

function Util:filter(array, predicate)
    local result = {}

    for _, item in ipairs(array) do
        if predicate(item) then
            result[#result+1] = item
        end
    end

    return result
end

function Util:randomItem(array)
    -- TODO
    return array[1]
end