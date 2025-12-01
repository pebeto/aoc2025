file = open("./input", "r")

function calculate_password(file::IOStream)::Int64
    dial = 50
    password = 0
    
    for line in (file |> eachline)
        movement = line[1]
        number = parse(Int, line[2:end])
        delta = movement == 'R' ? number : -number

        if delta >= 0
            password += ((dial + delta) / 100) |> floor
        else
            password += (((100 - dial) % 100 - delta) / 100) |> floor
        end
        dial = mod(dial + delta, 100)
    end
    return password
end

println("Part 2 password: ", (file |> calculate_password))
