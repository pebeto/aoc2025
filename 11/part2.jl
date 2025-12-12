using Graphs

file = open("./input", "r")

function count_paths_to_exit(
    graph::AbstractGraph,
    current::Integer,
    exit::Integer,
    dac::Integer,
    fft::Integer,
    seen_dac::Bool,
    seen_fft::Bool,
    memo::AbstractDict{<:Tuple{Integer,Bool,Bool},<:Integer},
)::Int64
    if current == dac
        seen_dac = true
    elseif current == fft
        seen_fft = true
    end

    if current == exit
        return (seen_dac && seen_fft) ? 1 : 0
    end

    key = (current, seen_dac, seen_fft)
    if haskey(memo, key)
        return memo[key]
    end

    total_paths = 0
    for neighbor in outneighbors(graph, current)
        total_paths += count_paths_to_exit(
            graph,
            neighbor,
            exit,
            dac,
            fft,
            seen_dac,
            seen_fft,
            memo,
        )
    end

    memo[key] = total_paths
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
        device_indexes["svr"],
        device_indexes["out"],
        device_indexes["dac"],
        device_indexes["fft"],
        false,
        false,
        Dict{Tuple{Int64,Bool,Bool},Int64}(),
    )
end

println("Total exit paths: ", (file |> get_total_exit_paths))
