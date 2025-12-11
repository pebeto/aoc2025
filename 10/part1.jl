file = open("./input", "r")

Machine = NamedTuple{(:target, :operations),Tuple{Vector{Int},Vector{Vector{Int}}}}

function gosper_hack(n::Int)
    c = n & -n
    r = n + c
    return (((xor(r, n) >> 2) / c) |> floor |> Int) | r
end

function solve_machine(target::Vector{Int}, operations::Vector{Vector{Int}})
    target_int = (target[i] << (i - 1) for i in 1:(target|>length)) |> sum
    operations_int = [((1 << pos for pos in op) |> sum) for op in operations]
    limit = 1 << (operations_int |> length)

    for set in 1:(operations_int|>length)
        n = (1 << set) - 1

        while n < limit
            result = 0
            temp = n
            idx = 0
            while temp > 0
                if (temp & 1) == 1
                    result = xor(result, operations_int[idx+1])
                end
                temp >>= 1
                idx += 1
            end

            if result == target_int
                return set
            end

            n = n |> gosper_hack
        end
    end
    return 0
end

function compute_total_fewest_button_presses(file::IOStream)::Int64
    total_presses = 0

    machines = Vector{Machine}()

    for line in (file |> eachline)
        line = line |> strip

        target_match = match(r"\[([.#]+)\]", line)
        target_str = target_match.captures[1]
        target = [c == '#' ? 1 : 0 for c in target_str]

        operations = Vector{Vector{Int}}()
        for m in eachmatch(r"\(([0-9,]+)\)", line)
            op_str = m.captures[1]
            op = parse.(Int, split(op_str, ','))
            push!(operations, op)
        end

        push!(machines, (target=target, operations=operations))
    end

    for machine in machines
        total_presses += solve_machine(machine.target, machine.operations)
    end
    return total_presses
end

println("Fewest button presses: ", (file |> compute_total_fewest_button_presses))
