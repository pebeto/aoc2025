using JuMP
using HiGHS

file = open("./input", "r")

Machine = NamedTuple{(:joltage, :operations),Tuple{Vector{Int},Vector{Vector{Int}}}}

function solve_machine(
    joltage::AbstractVector{Int64},
    operations::AbstractVector{<:AbstractVector{Int64}}
)::Int64
    joltage_length = joltage |> length
    operations_length = operations |> length

    model = HiGHS.Optimizer |> Model

    @variable(model, x[1:operations_length] >= 0, Int)

    for i in 1:joltage_length
        counter_sum = @expression(model, ((x[j] for j in 1:operations_length if (i - 1) in operations[j]) |> sum))

        @constraint(model, counter_sum == joltage[i])
    end

    @objective(model, Min, (x |> sum))
    optimize!(model)

    if (model |> termination_status) == MOI.OPTIMAL
        return model |> objective_value |> round |> Int
    end
    return 0
end

function compute_total_fewest_button_presses(file::IOStream)::Int64
    total_presses = 0

    machines = Vector{Machine}()

    for line in (file |> eachline)
        line = line |> strip

        operations = []
        for m in eachmatch(r"\(([0-9,]+)\)", line)
            op_str = m.captures[1]
            op = parse.(Int, split(op_str, ','))
            push!(operations, op)
        end

        joltage_match = match(r"\{([0-9,]+)\}", line)
        joltage_str = joltage_match.captures[1]
        joltage = parse.(Int, split(joltage_str, ','))

        push!(machines, (joltage=joltage, operations=operations))
    end

    for machine in machines
        result = solve_machine(machine.joltage, machine.operations)
        total_presses += result
    end
    return total_presses
end

println("Fewest button presses: ", (file |> compute_total_fewest_button_presses))
