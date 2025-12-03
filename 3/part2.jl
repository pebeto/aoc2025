file = open("./input", "r")

function get_total_output_joltage(file::IOStream)::Int64
    total = 0

    for line in (file |> eachline)
        numbers_to_remove = (line |> length) - 12
        bank_digits = line |> collect
        stack = Char[]

        for digit in bank_digits
            while !(stack |> isempty) && numbers_to_remove > 0 && stack[end] < digit
                stack |> pop!
                numbers_to_remove -= 1
            end
            push!(stack, digit)
            println(stack)
        end

        while numbers_to_remove > 0
            stack |> pop!
            numbers_to_remove -= 1
        end
        total += parse(Int, (stack |> String))
    end

    return total
end

println("Total output joltage: ", (file |> get_total_output_joltage))
