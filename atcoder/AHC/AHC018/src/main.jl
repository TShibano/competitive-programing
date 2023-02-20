# AHC018 - main.jl
# Date: 2023/02/20
# Version: 0.0.0
#== Solution
==#

# library ====
# using Primes
# using DataStructures

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parse_list_int(str=readline()) = parse.(Int64, split(str))
parse_int(str=readline()) = parse(Int64, str)

# composite types ====


# body ====

struct Input
    N::Int64
    W::Int64
    K::Int64
    C::Int64
    Water::Matrix{Int64}
    House::Matrix{Int64}
end

struct Output
    y::Int64
    x::Int64
    power::Int64
end

struct ExeResult
    r::Int64
end


struct BedRock
    matrix::Matrix{Int64}
end



function parser_input()::Input
    N, W, K, C = parse_list_int()
    water = Matrix{Int64}(undef, W, 2)
    house = Matrix{Int64}(undef, K, 2)
    for i in 1:W
        a, b = parse_list_int()
        a += 1
        b += 1
        water[i, :] = [a, b]
    end
    for i in 1:K
        c, d = parse_list_int()
        c += 1
        d += 1
        house[i, :] = [c, d]
    end
    return Input(N, W, K, C, water, house)
end


function parser_output(output::Output)::Nothing
    println(output.y, " ", output.x, " ", output.power)
end

function check_result(res::ExeResult)
    if res.r == -1
        error("Output Error: r is strange.")
    elseif r == 0
    elseif r == 1
    elseif r ==2
    else
        error("Output Error: r is out of range.")
end


function solve()
    
end

function main()
    input = parser_input()
end

main()
