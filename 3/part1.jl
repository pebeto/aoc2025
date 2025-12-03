file = open("./input", "r")

function get_total_output_joltage(file::IOStream)::Int64
    total = 0

    for line in (file |> eachline)
        bank_digits = [parse(Int, c) for c in line]

        first_digit, first_idx = bank_digits |> findmax
        bank_digits_copy = bank_digits |> deepcopy
        deleteat!(bank_digits_copy, first_idx)

        if first_idx == (bank_digits |> length)
            second_digit = first_digit
            first_digit = bank_digits_copy |> maximum
        else
            second_digit = bank_digits_copy[first_idx:end] |> maximum
        end

        total += first_digit * 10 + second_digit
    end
    return total
end

println("Total output joltage: ", (file |> get_total_output_joltage))
