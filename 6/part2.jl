file = open("./input", "r")

function get_grand_total(file::IOStream)::Int64
    total = 0
    lines = split(read(file, String), "\n"; keepempty=false)

    numeric_rows = lines[1:end-1]
    operator_row = lines[end]

    separator_indexes = findall(==('|'), replace(operator_row, r" (?=[\*\+])" => "|"))

    separated_numeric_rows = map(numeric_rows) do row
        chars = row |> collect
        for i in separator_indexes
            if i ≤ (chars |> length)
                chars[i] = '|'
            end
        end
        chars |> join
    end

    numeric_cols = [replace.(split(row, '|'), ' ' => 'x') for row in separated_numeric_rows]
    operators = (operator_row |> split)

    operations = Vector{Tuple{String,Vector{String}}}(undef, operators |> length)

    for i in 1:(operators|>length)
        col = Vector{String}(undef, numeric_cols |> length)
        for j in 1:(numeric_cols|>length)
            col[j] = numeric_cols[j][i]
        end
        operations[i] = (operators[i], col)
    end

    for operation in operations
        op = operation[1] |> Meta.parse |> eval
        numbers = operation[2]
        rlc_numbers = fill("", numbers |> first |> length)

        for number in numbers
            for (i, char) in (number |> enumerate)
                rlc_numbers[i] *= char == 'x' ? "" : char
            end
        end
        total += reduce(op, parse.(Int, rlc_numbers))
    end
    return total
end

println("Grand total: ", (file |> get_grand_total))
