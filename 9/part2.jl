file = open("./input", "r")

function is_valid_rectangle(
    red_tiles::Vector{Tuple{Int64,Int64}},
    x_min::Int64,
    x_max::Int64,
    y_min::Int64,
    y_max::Int64,
)::Bool
    for (xt, yt) in red_tiles
        if x_min < xt < x_max && y_min < yt < y_max
            return false
        end
    end

    n = red_tiles |> length

    for i in 1:n
        x1, y1 = red_tiles[i]
        x2, y2 = red_tiles[mod1(i + 1, n)]

        if x1 == x2
            x = x1
            yA = min(y1, y2)
            yB = max(y1, y2)

            if x_min < x < x_max && max(yA, y_min) < min(yB, y_max)
                return false
            end

        elseif y1 == y2
            y = y1
            xA = min(x1, x2)
            xB = max(x1, x2)

            if y_min < y < y_max && max(xA, x_min) < min(xB, x_max)
                return false
            end
        end
    end

    return true
end

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

            x_min, x_max = min(x1, x2), max(x1, x2)
            y_min, y_max = min(y1, y2), max(y1, y2)

            if is_valid_rectangle(red_tiles, x_min, x_max, y_min, y_max)
                push!(areas, (abs(x_max - x_min) + 1) * (abs(y_max - y_min) + 1))
            end
        end
    end
    return areas |> maximum
end

println("Largest area rectangle: ", (file |> get_largest_area_rectangle))
