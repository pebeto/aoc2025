file = open("./input", "r")

function get_largest_area_rectangle(file::IOStream)::Int64
    areas = Vector{Int64}()
    lines = split(read(file, String), '\n'; keepempty=false)
    red_tiles = Vector{Tuple{Int64,Int64}}()

    for line in lines
        coords = parse.(Int, split(line, ','))
        x, y = coords[1], coords[2]
        push!(red_tiles, (x, y))
    end

    n_red_tiles = red_tiles |> length

    for i in 1:n_red_tiles
        for j in i+1:n_red_tiles
            x1, y1 = (red_tiles[i] |> first), (red_tiles[i] |> last)
            x2, y2 = (red_tiles[j] |> first), (red_tiles[j] |> last)
            push!(areas, (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1))
        end
    end
    return areas |> maximum
end

println("Largest area rectangle: ", (file |> get_largest_area_rectangle))
