local module = {}

function module.crop2D(matrix)

    local function x_nil(row)
        for _, v in pairs(row) do
            if v ~= 0 then
                return false
            end
        end
        return true
    end

    local function y_nil(matrix, col)
        for i = 1, #matrix do
            if matrix[i][col] ~= 0 then
                return false
            end
        end
        return true
    end

    if #matrix == 0 or (#matrix == 1 and #matrix[1] == 0) then
        return {}
    end

    local start_row, end_row = 1, 3
    local start_col, end_col = 1, 3

    while start_row <= end_row and x_nil(matrix[start_row]) do
        start_row = start_row + 1
    end

    while end_row >= start_row and x_nil(matrix[end_row]) do
        end_row = end_row - 1
    end

    while start_col <= end_col and y_nil(matrix, start_col) do
        start_col = start_col + 1
    end

    while end_col >= start_col and y_nil(matrix, end_col) do
        end_col = end_col - 1
    end

    local cropped_matrix = {}

    for i = start_row, end_row do
        local new_row = {}
        for j = start_col, end_col do
            new_row[j - start_col + 1] = matrix[i][j]
        end
        table.insert(cropped_matrix, new_row)
    end

    return cropped_matrix, {start_row, end_row, start_col, end_col}
end

function module.uncrop2D(cropped_matrix, bounds)
    local start_row, end_row, start_col, end_col = unpack(bounds)

    local original_rows = math.max(end_row, 3)
    local original_cols = math.max(end_col, 3)

    local original_matrix = {}
    for i = 1, original_rows do
        original_matrix[i] = {}
        for j = 1, original_cols do
            original_matrix[i][j] = 0
        end
    end

    for i = start_row, end_row do
        for j = start_col, end_col do
            if cropped_matrix[i - start_row + 1] and cropped_matrix[i - start_row + 1][j - start_col + 1] then
                original_matrix[i][j] = cropped_matrix[i - start_row + 1][j - start_col + 1]
            end
        end
    end

    return original_matrix
end


function module.equals(matrix1, matrix2)
    if type(matrix1) ~= type(matrix2) then
        return false
    end

    if type(matrix1) ~= 'table' then
        return matrix1 == matrix2
    end

    local keys1 = {}
    local keys2 = {}

    for k in pairs(matrix1) do
        keys1[k] = true
    end

    for k in pairs(matrix2) do
        keys2[k] = true
    end

    for k in pairs(keys1) do
        if not keys2[k] or not module.equals(matrix1[k], matrix2[k]) then
            return false
        end
    end

    for k in pairs(keys2) do
        if not keys1[k] then
            return false
        end
    end

    return true
end

return module