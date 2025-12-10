file = open("./input", "r")

function get_total_beam_splits(file::IOStream)::Int64
    total = 0
    lines = split(read(file, String), '\n')
    paths = lines |> first |> length |> falses
    data = [(line |> collect) for line in lines if any(!=('.'), line)]
    s_index = findfirst(==('S'), (data |> first))
    paths[s_index] = true

    for row in data[2:end]
        old_paths = paths |> copy

        for (i, used) in (old_paths |> pairs)
            if row[i] == '^'
                paths[i] = false
                paths[i-1] = true
                paths[i+1] = true
                total += used
            end
        end
    end

    return total
end

println("Total beam splits: ", (file |> get_total_beam_splits))
