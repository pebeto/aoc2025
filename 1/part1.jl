file = open("./input", "r")

function calculate_password(file::IOStream)::Int64
    dial = 50
    password = 0
    
    for line in (file |> eachline)
        movement = line[1]
        number = parse(Int, line[2:end])
        delta = movement == 'R' ? number : -number

        dial += delta
        password += (dial % 100 == 0) |> Int
    end
    return password
end

println("Part 1 password: ", (file |> calculate_password))
