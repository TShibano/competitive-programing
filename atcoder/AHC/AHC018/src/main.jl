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
#
struct Coord
    x::Int64
    y::Int64
end

struct Input
    N::Int64
    W::Int64
    K::Int64
    C::Int64
    Water::Vector{Coord}
    House::Vector{Coord}
end

struct Output
    coord::Coord
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
    water = Vector{Coord}(undef, W)
    house = Vector{Coord}(undef, K)
    for i in 1:W
        y, x = parse_list_int()
        y += 1
        x += 1
        water[i] = Coord(x, y)
    end
    for i in 1:K
        y, x = parse_list_int()
        y += 1
        x += 1
        house[i, :] = Coord(x, y)
    end
    return Input(N, W, K, C, water, house)
end


function parser_output(output::Output)::Nothing
    println(output.coord.y, " ", output.coord.x, " ", output.power)
end

"""TODO"""
function check_result(res::ExeResult)
    if res.r == -1
        error("Output Error: r is strange.")
    elseif r == 0
        pass
    elseif r == 1
        pass
    elseif r ==2
        pass
    else
        error("Output Error: r is out of range.")
    end
end

"""2点のL1距離(マンハッタン距離)を求める"""
function calc_l1(coord1::Coord, coord2::Coord)::Int64
    return abs(coord1.x - coord2.x) + abs(coord1.y - coord2.y)
end

"""水源にL1距離が最も近い水源を探す"""
function greed_clustering(input::Input)
    
end


function solve()
    
end

function main()
    input = parser_input()
end

main()
