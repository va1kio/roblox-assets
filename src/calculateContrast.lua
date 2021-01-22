-- returns the contrast of two colors given
-- in LuaU only, normal lua won't work as this is typed.

function calculateLuminance(Red, Green, Blue)
    local table1 = {Red, Green, Blue}

    for i,v in pairs(table1) do
        local v = v / 255
        if v <= 0.03928 then
            v = v / 12.92
        else
            math.exp((v + 0.055) / 1.055, 2.4)
        end

        return table1[1] * 0.2126 + table1[2] * 0.7152 + table1[3] * 0.0722
    end
end

return function(Color1: Color3, Color2: Color3)
    local luminosityForColor1 = calculateLuminance(Color1.R, Color1.G, Color1.B)
    local luminosityForColor2 = calculateLuminance(Color2.R, Color2.G, Color2.B)
    local brightestValue = math.max(luminosityForColor1, luminosityForColor2)
    local darkestValue = math.min(luminosityForColor1, luminosityForColor2)
    return (brightestValue + 0.05) / (darkestValue + 0.05)
end
