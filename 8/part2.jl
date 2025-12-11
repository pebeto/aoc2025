file = open("./input", "r")

Position = NamedTuple{(:x, :y, :z),Tuple{Int64,Int64,Int64}}

function distance(a::Position, b::Position)::Float64
    return ((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2) |> sqrt
end

function find(parent::Vector{Int64}, x::Int64)::Int64
    while parent[x] != x
        parent[x] = parent[parent[x]]
        x = parent[x]
    end
    return x
end

function union(parent::Vector{Int64}, size::Vector{Int64}, a::Int64, b::Int64)::Bool
    ra = find(parent, a)
    rb = find(parent, b)

    if ra == rb
        return false
    end

    if size[ra] < size[rb]
        ra, rb = rb, ra
    end

    parent[rb] = ra
    size[ra] += size[rb]
    return true
end

function get_last_connection_x_product(file::IOStream)::Int64
    lines = split(read(file, String), '\n'; keepempty=false)
    boxes = Vector{Position}()

    for line in lines
        coords = parse.(Int, split(line, ','))
        x, y, z = coords[1], coords[2], coords[3]
        push!(boxes, (x=x, y=y, z=z))
    end

    n_boxes = boxes |> length

    edges = Tuple{Float64,Int64,Int64}[]
    for i in 1:n_boxes
        bi = boxes[i]
        for j in (i+1):n_boxes
            bj = boxes[j]
            push!(edges, (distance(bi, bj), i, j))
        end
    end
    sort!(edges, by=x -> x[1])

    parent = 1:n_boxes |> collect
    size = ones(Int, n_boxes)

    components = n_boxes
    last_i = 0
    last_j = 0

    for k in 1:(edges|>length)
        _, i, j = edges[k]
        if union(parent, size, i, j)
            components -= 1
            if components == 1
                last_i = i
                last_j = j
                break
            end
        end
    end

    return boxes[last_i].x * boxes[last_j].x
end

println(
    "Last required connection X-product: ",
    (file |> get_last_connection_x_product),
)
