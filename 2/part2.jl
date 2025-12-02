file = open("./input", "r")

function isinvalid(number::Int64)::Bool
    num_digits = number |> ndigits

    for pattern_length in 1:(num_digits/2)
        if !(num_digits % pattern_length |> iszero)
            continue
        end

        divisor = 10^pattern_length
        expected = number % divisor * ((divisor^(num_digits / pattern_length) - 1) / (divisor - 1))

        if expected == number
            return true
        end
    end
    return false
end

function sum_invalid_ids(file::IOStream)#::Int64
    line = readline(file)
    ranges = [(replace(range, "-" => ":") |> Meta.parse |> eval) for range in split(line, ",")]
    return mapreduce(range -> sum((number |> isinvalid) ? number : 0 for number in range), +, ranges)
end

println("Sum of invalid IDs: ", (file |> sum_invalid_ids))
