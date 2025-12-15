file = open("./input", "r")

function get_total_region_fits(file::IOStream)::Int64
    total = 0
    data = file |> readlines

    areas = []
    for line in data[31:end]
        sections = split(line, ":")
        shape = [parse(Int, n) for n in split(sections[1], "x")]
        distribution = [parse(Int, n) for n in split((sections[2] |> strip), " ")]
        push!(areas, (w=shape[1], h=shape[2], distribution=distribution))
    end

    for area in areas
        if ((area.w / 3) |> round) * ((area.h / 3) |> round) >= (area.distribution |> sum)
            total += 1
        end
    end

    return total
end

println("Total region fits: ", (file |> get_total_region_fits))
