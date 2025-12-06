file = open("./input", "r")

function get_grand_total(file::IOStream)::Int64
    total = 0
    lines = split(read(file, String), "\n"; keepempty=false)

    numeric_rows = lines[1:end-1]
    operator_row = lines[end]

    numeric_cols = [parse.(Int, (row |> split)) for row in numeric_rows]
    operators = (operator_row |> split)

    operations = Vector{Tuple{String,Vector{Int64}}}(undef, operators |> length)

    for i in 1:(operators|>length)
        col = Vector{Int64}(undef, numeric_cols |> length)
        for j in 1:(numeric_cols|>length)
            col[j] = numeric_cols[j][i]
        end
        operations[i] = (operators[i], col)
    end

    for operation in operations
        op = operation[1] |> Meta.parse |> eval
        nums = operation[2]

        total += reduce(op, nums)
    end
    return total
end

println("Grand total: ", (file |> get_grand_total))
