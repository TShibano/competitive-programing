# AHC018 - main.jl
# Date: 2023/02/20
# Version: 1.0.0
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


mutable struct Field
    is_crushed::Matrix{Bool}
    sturdiness::Matrix{Int64}
    function Field(input::Input)
        is_crushed = falses(input.N, input.N)
        sturdiness = zeros(Int64, input.N, input.N)
        new(is_crushed, sturdiness)
    end
end


function check_field(field::Field, coord::Coord)::Bool
    return field.is_crushed[coord.y, coord.x]
end

function crushed_at_coord!(field::Field, coord::Coord)::Nothing
    field.is_crushed[coord.y, coord.x] = true
    return nothing
end

function update!(field::Field, coord::Coord, power::Int64)::Nothing
    field.sturdiness[coord.y, coord.x] += power
    return nothing
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


"""出力する"""
function parser_output(output::Output)::Nothing
    println(output.coord.y-1, " ", output.coord.x-1, " ", output.power)
end

"""出力に対する入力を受け取る"""
function parser_input_interactive()::Result
    r = parse_int()
    return Result(r)
end

"""出力を与えて入力を受け取る"""
function interactive(output::Output)::Result
    parser_output(output)
    return parser_input_interactive()
end

"""TODO"""
function check_result(res::Result)
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
        sum_y += coord_list[i].y
    end
    # 整数にする必要あり
    gx = sum_x ÷ n
    gy = sum_y ÷ n
    return Coord(gx, gy)
end


"""壊す座標"""
function crush!(field::Field, coord::Coord, power::Int64)::Bool
    if check_field(field, coord)    # すでに壊されている場合
        return true
    else
        output = Output(coord, power)
        update!(field, coord, power)    # 頑丈さの更新
        res::Result = interactive(output)
        if res.r == 0       # 指定した座標の岩盤はまだ壊れていない
            return false
        elseif res.r == 1   # 指定した座標の岩盤が壊れた
            crushed_at_coord!(field, coord)      # 
            return true
        elseif res.r == 2   # すぐに終了する
            exit()
        end
    end
end

"""パスを見つける
(now)ver. 1.0: 単純にスタート地点とゴール地点を結ぶ
ver. 1.1: ゴール地点もしくは近くのすでに掘られている地点を探しに行く
"""
function find_path(s_coord, g_coord, field)::Vector{Coord}
    path = Coord[]
    # y軸方向をまず決める
    if s_coord.y <= g_coord.y
        for i in s_coord.y:g_coord.y
            push!(path, Coord(s_coord.x, i))
        end
    else
        for i in s_coord.y:-1:g_coord.y
            push!(path, Coord(s_coord.x, i))
        end
    end
    # x軸方向を決める
    if s_coord.x <= g_coord.x
        for i in s_coord.x+1:g_coord.x
            push!(path, Coord(i, g_coord.y))
        end
    else
        for i in s_coord.x-1:-1:g_coord.x
            push!(path, Coord(i, g_coord.y))
        end
    end
    return path
end

"""スタート地点とゴール地点を与えて掘り進める"""
function crush_goal!(s_coord::Coord, g_coord::Coord, power::Int64, field::Field)
    #println("Now crush_goal!")
    path = find_path(s_coord, g_coord, field)
    #println("#", path)
    for i in 1:length(path)
        now_coord = path[i]
        if check_field(field, now_coord)
            continue
        end
        while true
            response = crush!(field, now_coord, power)
            if response     # 指定した座標が壊れている場合次に行く
                break
            end
        end
    end
end

function solve1_0(input::Input, field::Field)
    power = 100
    # クラスタリングする
    clusters = clustering_nearing_water(input)
    # クラスタリングしたグループ内での重心を求める
    target_coord_list = Coord[]
    for i in 1:input.W
        # グループに水源が入っていないので追加する
        tmp_clusters = Coord[]
        for id in clusters[i]
            push!(tmp_clusters, input.House[id])
        end
        push!(tmp_clusters, input.Water[i])
        println("# clusters: ", tmp_clusters)
        push!(target_coord_list, calc_center(tmp_clusters))
    end
    println("#", target_coord_list)
    # 同一グループはその重心を目掛けて掘り進める
    for w in 1:input.W    # 水の数がグループの数
        n = length(clusters[w])
        println("# クラスター内の個数", n)
        println("# cluster", w)
        if n == 0       # この水源は家がないので掘らなくてよい
            println("# No House")
            continue
        end
        g_coord = target_coord_list[w]    # このグループの目標となる座標(重心)
        s_coord = input.Water[w]
        # 水源から目標地点に掘り進める
        crush_goal!(s_coord, g_coord, power, field)
        # 家から目標地点に掘り進める
        for i in 1:n
            s_coord = input.House[clusters[w][i]]
            crush_goal!(s_coord, g_coord, power, field)
        end
    end
    println("# 最後まできた")
end

function main()
    input = parser_input()
    field = Field(input)
    solve1_0(input, field)
end

main()
