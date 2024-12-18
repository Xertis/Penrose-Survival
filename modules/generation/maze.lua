local module = {}

function table.shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end

    return t
end

function table.gen_matrix(rows, cols, e)
    e = e or 0
    local matrix = {}

    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = e
        end
    end

    return matrix
end

function module.place(rX, rY, direction)
    if direction == 1 then
        return rX - 2, rY
    elseif direction == 2 then
        return rX + 2, rY
    elseif direction == 3 then
        return rX, rY - 2
    elseif direction == 4 then
        return rX, rY + 2
    end
end

function module.is_valid(matrix, x, y)
    return x > 0 and x < #matrix and y > 0 and y <= #matrix[1] and matrix[x][y] == 0
end

function module.gen(matrix, visited)
    local len = #visited
    for j=1, len do
        local vis = visited[j]
        local rX, rY = vis[1], vis[2]
        local directions = {1, 2, 3, 4}

        directions = table.shuffle(directions)

        for _, dir in ipairs(directions) do
            local newX, newY = module.place(rX, rY, dir)

            if module.is_valid(matrix, newX, newY) then
                matrix[newX][newY] = 1
                matrix[math.floor(rX + (newX - rX) / 2)][math.floor(rY + (newY - rY) / 2)] = 1

                table.insert(visited, {newX, newY})
                break
            end
        end
    end

    return matrix, visited
end

function module.gen_maze(w, h, i)
    local maze = table.gen_matrix(w, h)

    local rx, ry = math.random(w), math.random(h)
    maze[rx][ry] = 1

    local visited = {{rx, ry}}

    for _=1, i do
        maze, visited = module.gen(maze, visited)
    end

    return maze
end

return module