file = open("./input", "r")

function get_total_beam_splits(file::IOStream)::Int64
    lines = split(read(file, String), '\n')
    data = [(line |> collect) for line in lines if any(!=('.'), line)]
    paths = zeros(Int, (data |> first |> length))
    s_index = findfirst(==('S'), (data |> first))
    paths[s_index] = true

    for row in data[2:end]
        old_paths = paths |> copy

        for (i, count) in (old_paths |> pairs)
            if row[i] == '^'
                paths[i] = 0
                paths[i-1] += count
                paths[i+1] += count
            end
        end
    end

    return paths |> sum
end

println("Total beam splits: ", (file |> get_total_beam_splits))
