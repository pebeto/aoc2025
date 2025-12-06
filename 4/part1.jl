file = open("./input", "r")

isroll(char::Char)::Bool = char == '@'

function get_total_accessible_rolls(file::IOStream)::Int64
    total = 0
    roll_matrix = split(read(file, String), "\n")
    nlines = roll_matrix |> length

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
                        if (roll_matrix[ni][nj] |> isroll)
                            adjacent_rolls += 1
                        end
                    end
                end
            end
            total += adjacent_rolls < 4
            adjacent_rolls = 0
        end
    end

    return total
end

println("Total accessible rolls: ", (file |> get_total_accessible_rolls))
