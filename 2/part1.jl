file = open("./input", "r")

function isinvalid(number::Int64)::Bool
    power = ((number |> ndigits) / 2) |> floor
    return (number / 10^power |> floor) == (number % 10^power |> floor)
end

function sum_invalid_ids(file::IOStream)#::Int64
    line = readline(file)
    ranges = [(replace(range, "-" => ":") |> Meta.parse |> eval) for range in split(line, ",")]
    return mapreduce(range -> sum((number |> isinvalid) ? number : 0 for number in range), +, ranges)
end

println("Sum of invalid IDs: ", (file |> sum_invalid_ids))
