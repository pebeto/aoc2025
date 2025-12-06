file = open("./input", "r")

function get_total_fresh_ingredients(file::IOStream)::Int64
    total = 0
    ranges = Vector{UnitRange{Int64}}()
    id_marker = false

    for line in (file |> eachline)
        if (line |> isempty)
            id_marker = true
            continue
        end

        if id_marker
            id = parse(Int, line)
            for range in ranges
                if id in range
                    total += 1
                    break
                end
            end
        else
            ranges = push!(ranges, (replace(line, "-" => ":") |> Meta.parse |> eval))
        end

    end

    return total
end

println("Total fresh ingredients: ", (file |> get_total_fresh_ingredients))
