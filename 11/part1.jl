using Graphs

file = open("./input", "r")

function count_paths_to_exit(
    graph::AbstractGraph,
    current::Integer,
    exit::Integer,
    memo::AbstractDict{<:Integer,<:Integer},
)::Int64
    if current == exit
        return 1
    end
    if haskey(memo, current)
        return memo[current]
    end

    total_paths = 0
    for neighbor in outneighbors(graph, current)
        total_paths += count_paths_to_exit(graph, neighbor, exit, memo)
    end

    memo[current] = total_paths
    return total_paths
end

function get_total_exit_paths(file::IOStream)::Int64
    total = 0

    device_map = Dict{String,Vector{String}}()

    for line in (file |> eachline)
        parts = replace(line, ':' => "") |> split
        device = parts[1]
        outputs = parts[2:end]

        device_map[device] = outputs
    end
    device_map["out"] = Vector{String}()

    device_names = device_map |> keys |> collect
    device_indexes = (device_names .=> (1:(device_names|>length))) |> Dict
    device_graph = device_names |> length |> SimpleDiGraph

    for (device, outputs) in device_map
        for output_device in outputs
            add_edge!(device_graph, device_indexes[device], device_indexes[output_device])
        end
    end

    return count_paths_to_exit(
        device_graph,
        device_indexes["you"],
        device_indexes["out"],
        Dict{Int64,Int64}(),
    )
end

println("Total exit paths: ", (file |> get_total_exit_paths))
