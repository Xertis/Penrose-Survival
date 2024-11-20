
function table.easy_concat(tbl)
    local output = ""
    for i, value in pairs(tbl) do
        output = output .. tostring(value)
        if i ~= #tbl then
            output = output .. ", "
        end
    end
    return output
end

function table.equals(tbl1, tbl2)
    return table.easy_concat(tbl1) == table.easy_concat(tbl2)
end