-- textUtils.lua

local M = {}

function M.typeText(font, text, speed, index, wrapX)
    local s = ""
    local lineWidth = 0
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    local wordIndex = 1
    while wordIndex <= #words and index > 0 do
        local word = words[wordIndex]
        local wordWidth = font:getWidth(word)
        if lineWidth + wordWidth > wrapX then
            s = s .. "\n"
            lineWidth = 0
        end
        if index >= #word + 1 then
            s = s .. word .. " "
            lineWidth = lineWidth + wordWidth + font:getWidth(" ")
            index = index - #word - 1
            wordIndex = wordIndex + 1
        else
            local partialWord = word:sub(1, index)
            s = s .. partialWord
            lineWidth = lineWidth + font:getWidth(partialWord)
            index = 0
        end
    end
    return s
end

return M
