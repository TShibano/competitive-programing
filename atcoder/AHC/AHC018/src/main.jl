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
"""2次元座標"""
struct Coord
    x::Int64
    y::Int64
end

"""問題の入力
N: グリッドの幅(N×Nマス)
W: 水源の数
K: 家の数
C: 消費する体力のベース値
Water: W個の水源の位置を格納した配列
House: K個の家の位置を格納した配列
"""
struct Input
    N::Int64
    W::Int64
    K::Int64
    C::Int64
    Water::Vector{Coord}
    House::Vector{Coord}
end

"""問題の出力"""
struct Output
    coord::Coord
    power::Int64
end

struct Result
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
        house[i] = Coord(x, y)
    end
    return Input(N, W, K, C, water, house)
end


function parser_output(output::Output)::Nothing
    println(output.coord.y, " ", output.coord.x, " ", output.power)
end

function parser_input_interactive()::Result
    r = parse_int()
    return Result(r)
end

function interactive(output::Output)::Result
    parser_output(output)
    return parser_input_interactive()
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
function clustering_nearing_water(input::Input)::Vector{Vector{Int64}}
    # 水源に対してクラスタリングする家を2次元リストで格納する
    res = [[] for _ in 1:input.W]
    for k in 1:input.K
        l1 = 10^6
        nearist_water_id = 0
        now_house = input.House[k]
        for w in 1:input.W
            now_water = input.Water[w]
            tmp_l1 = calc_l1(now_house, now_water)
            if l1 > tmp_l1
                nearist_water_id = w
                l1 = tmp_l1
            else
                continue
            end
        end
        push!(res[nearist_water_id], k)
    end
    return res
end

"""
    calc_center(coord_list::Vector{Coord})::Coord

複数点の重心を求める
"""
function calc_center(coord_list::Vector{Coord})::Coord
    n = length(coord_list)
    sum_x = 0
    sum_y = 0
    for i in 1:n
        sum_x += coord_list[i].x
        sum_y += coord_list[y].y
    end
    # 整数にする必要あり
    gx = sum_x ÷ n
    gy = sum_y ÷ n
    return Coord(gx, gy)
end


function solve1_0(input::Input)
    # クラスタリングする
    # クラスタリングしたグループ内での重心を求める
    # 同一グループはその重心を目掛けて掘り進める
    #
end

function main()
    input = parser_input()
end

main()
