file = open("./input", "r")

function get_total_fresh_ingredients(file::IOStream)::Int64
    ranges = Vector{UnitRange{Int64}}()

    for line in (file |> eachline)
        if (line |> isempty)
            break
        end
        ranges = push!(ranges, (replace(line, "-" => ":") |> Meta.parse |> eval))
    end

    total = 0
    sorted_ranges = sort(ranges, by=first)
    current_start = sorted_ranges |> first |> first
    current_end = sorted_ranges |> first |> last

    for range in sorted_ranges[2:end]
        if (range |> first) <= current_end + 1
            current_end = max(current_end, (range |> last))
        else
            total += current_end - current_start + 1

            current_start = range |> first
            current_end = range |> last
        end
    end

    total += current_end - current_start + 1
    return total
end

println("Total fresh ingredients: ", (file |> get_total_fresh_ingredients))
