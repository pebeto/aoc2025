file = open("./input", "r")

isroll(char::Char)::Bool = char == '@'
ischecked(char::Char)::Bool = char == 'x'

function get_total_accessible_rolls(file::IOStream)::Int64
    total = 0
    roll_matrix = split(read(file, String), "\n") .|> collect
    nlines = roll_matrix |> length

    iteration_total = -1
    while iteration_total != total
        iteration_total = total

        for (i, line) in (roll_matrix |> enumerate)
            for (j, char) in (line |> enumerate)
                adjacent_rolls = 0

                if !(char |> isroll)
                    continue
                end

                for di in -1:1
                    for dj in -1:1
                        if (di |> iszero) && (dj |> iszero)
                            continue
                        end

                        ni = i + di
                        nj = j + dj

                        if (1 <= ni <= nlines) && (1 <= nj <= (roll_matrix[ni] |> length))
                            target = roll_matrix[ni][nj]
                            if (target |> isroll || target |> ischecked)
                                adjacent_rolls += 1
                            end
                        end
                    end
                end
                removable = adjacent_rolls < 4
                total += removable
                roll_matrix[i][j] = removable ? 'x' : '@'
                adjacent_rolls = 0
            end
        end
        roll_matrix .|> (line -> replace!(line, 'x' => '.'))
    end

    return total
end

println("Total accessible rolls: ", (file |> get_total_accessible_rolls))
