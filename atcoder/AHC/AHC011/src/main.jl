# AHC011 - A.jl
# Date: 2022/05/28
# Version: 0.0.0
#== Solution
- 縦方向をy, 横方向をxとする．
- 二次元は考えやすいが，実装しにくいので，平面に落とし込む．
    - Juliaはcolumn-major　orderなので， node = y + n(x-1)で考える
    - 移動等は全て平面で考える．
- まずは盤面評価できるように，木の判定を出来るようにする．
    - 連結の判定は，常に左上から右 or 下側の判定を行うことで，4方向を実装しない．
    - 閉路の有無はUnion Find木で実装できないか．
==#

# library ====
using Dates
# using Random
# using Primes
# using DataStructures

# templete function ====
parseListInt(str=readline()) = parse.(Int, split(str))
parseInt(str=readline()) = parse(Int, str)

# const ====
const has_left_list = ['1', '3', '5', '7', '9', 'b', 'd', 'f']
const has_up_list = ['2', '3', '6', '7', 'a', 'b', 'e', 'f']
const has_right_list = ['4', '5', '6', '7', 'c', 'd', 'e', 'f']
const has_down_list = ['8', '9', 'a', 'b', 'c', 'd', 'e', 'f']


# body ====
Graph = Vector{Vector{Int}}

# UnionFind ====
"""Union Find tree type"""
struct UnionFind
    # rank: 木のランク．
    parents::Array{Int, 1}  # 親の頂点番号．負の場合，根であり，その木のサイズ数が入っている．
    rank::Array{Int, 1}
    loop_list::Array{Bool, 1}
    UnionFind(N) = new(fill(-1, N), zeros(N), falses(N))
end

"""木の根を求める"""
function find_root!(uf::UnionFind, x::Int)::Int
    if uf.parents[x] < 0
        return x
    else
        return uf.parents[x] = find_root!(uf, uf.parents[x])
    end
end

"""xとyの属する集合を併合"""
function unite!(uf::UnionFind, x::Int, y::Int)::Bool
    x = find_root!(uf, x)
    y = find_root!(uf, y)
    if x == y       # 閉路になる．
        # 根をLoop trueにする．
        uf.loop_list[x] = true
        return true
    end
    if uf.rank[x] < uf.rank[y]  # yの方が高い場合, xをyの下にはる．
        # つまり，xの根はyになる．
        # yのrankは固定のまま
        x_size = uf.parents[x]
        uf.parents[x] = y
        uf.parents[y] += x_size     # yのサイズを更新
        uf.loop_list[x] = uf.loop_list[y]
    else        # xの方が高い場合, yをxの下にはる．
        y_size = uf.parents[y]
        uf.parents[y] = x
        uf.parents[x] += y_size     # xのサイズを更新
        uf.loop_list[y] = uf.loop_list[x]
        if uf.rank[x] == uf.rank[y]
            uf.rank[x] += 1
        end
    end
    return true
end

"""xとyが同じ集合に属するか否か"""
function is_same!(uf::UnionFind, x::Int, y::Int)::Bool
    return find_root!(uf, x) == find_root!(uf, y)
end

"""xが属する木のサイズを求める"""
function calc_size(uf::UnionFind, x::Int)::Int
    return -uf.parents[find_root!(uf, x)]
end

"""閉路を持っているか否か"""
function has_loop(uf::UnionFind, x::Int)::Int
    return uf.loop_list[find_root!(uf, x)]
end
# ====


"""盤面をを表すための複合型"""
mutable struct Field
    n::Int  # 2次元マップ上での一辺の長さ
    size::Int   # 盤面の個数. n*nとなる．
    field::Vector{Char}     # 盤面は1次元で表し，Char型としている．
    zero_vertex::Int
    turn::Int
    T::Int
    Field(n, field, t) = new(n, n*n, field, -1, 0, t)
end

"""2次元平面上での左方向の移動を1次元上に換算する"""
function left(v::Int, field::Field)::Int
    nv = v - field.n
    return nv
end

"""2次元平面上での右方向の移動を1次元上に換算する"""
function right(v::Int, field::Field)::Int
    nv = v + field.n
    return nv
end

"""2次元平面上での上方向の移動を1次元上に換算する"""
function up(v::Int, field::Field)::Int
    nv = v - 1
    return nv
end

"""2次元平面上での下方向の移動を1次元上に換算する"""
function down(v::Int, field::Field)::Int
    nv = v + 1
    return nv
end

"""vからnvに移動が可能か"""
function can_move(v::Int, nv::Int, field::Field)::Bool
    if 1 <= nv && nv <= field.size  # ノードが場外に出ていない
        return true
    end
    return false
end

"""Stringの1次元配列で読み込んだ入力マップをChar型の配列に変換し, Field型変数を作成する"""
function initialize_field(init_field::Vector{String}, t::Int)::Field
    init_field_string = ""
    n = length(init_field)
    for x = 1:n
        for y = 1:n
            init_field_string *= string(init_field[y][x])
        end
    end
    initial_field = [s for s in init_field_string]
    field = Field(n, initial_field, t)
    return field
end

"""0の位置を見つける"""
function find_zero!(field::Field)::Int
    # idx = findfirst('0', field.field)
    for i in 1:field.size
        if field.field[i] == '0'
            field.zero_vertex = i
            return i
        end
    end
end

"""位置vが(二次元上の)右の側と繋がっているかの判定"""
function is_connect_right(v::Int, field::Field)::Bool
    nv = right(v, field)
    if can_move(v, nv, field)
        if field.field[v] in has_right_list && field.field[nv] in has_left_list
            return true
        end
    end
    return false
end

"""位置vが(二次元上の)の下側と繋がっているかの判定"""
function is_connect_down(v::Int, field::Field)::Bool
    nv = down(v, field)
    if can_move(v, nv, field)
        if field.field[v] in has_down_list && field.field[nv] in has_up_list
            return true
        end
    end
    return false
end

"""最も大きい木のサイズを求める．"""
function calc_maximum_tree_size(field::Field)::Int
    # 1. 連結しているノードを抽出する(隣接リストで持つ) -> Union Find を作る
    # 2. 閉路がないか調べる(Union Find木で実装する)
    # 3. 各木の連結成分数を調べる
    # 4. 最大値を返す．だ
    # NO TEST
    uf = create_UnionFind_from_now_field(field)
    uf_root_list = [i for i = 1:field.size if uf.parents[i] < 0]
    tmp_tree_size = 0
    for v in uf_root_list
        # println(uf.loop_list[v])
        if field.field[v] == '0'        # 0は得点計算に用いない
            continue
        end
        uf.loop_list[v] || (tmp_tree_size=maximum([tmp_tree_size, -uf.parents[v]]))   # vが閉路ではない時に連結成分を取得し，更新する．
    end
    println(uf)
    return maximum([0, tmp_tree_size])
end

"""スコア計算を行う"""
function calc_score(field::Field)::Float64
    tree_size = calc_maximum_tree_size(field)
    if tree_size == field.n^2 - 1
        return round(500_000 * (2-field.turn/field.T))
    else
        return round(500_000 * tree_size / (field.n^2 - 1))
    end
end


"""現在の盤面における，タイルの繋がりを隣接グラフとして作成する"""
function create_UnionFind_from_now_field(field::Field)::UnionFind
    uf = UnionFind(field.size)
    has_loop_root_list = Vector{Int}()
    for v = 1:field.size-1
        # 右方向を調べる
        if is_connect_right(v, field)
            nv = right(v, field)
            if is_same!(uf, v, nv)
                push!(has_loop_root_list, find_root!(uf, v))
                unite!(uf, v, nv)
            else
                unite!(uf, v, nv)
            end
        end
        # 下方向を調べる
        if is_connect_down(v, field)
            nv = down(v, field)
            if is_same!(uf, v, nv)
                push!(has_loop_root_list, find_root!(uf, v))
                unite!(uf, v, nv)
            else
                unite!(uf, v, nv)
            end
        end
    end
    return uf
    # return (uf, has_loop_root_list)
end

"""vの位置のタイルをnvの位置に移動する.移動できるのは前提"""
function swap_tile!(field::Field, v::Int, nv::Int)::Nothing
    if !can_move(v, nv, field)   # 保険
        println("Error: swap tile!")
        exit()
    end
    v_tile = field.field[v]
    nv_tile = field.field[nv]
    field.field[v] = nv_tile
    field.field[nv] = v_tile
    field.zero_vertex = nv
    field.turn += 1
    return 
end

""""""
function move_random_tile(field::Field)::Char
    # TODO
    v = field.zero_vertex       # 空白タイルの位置
    direction = rand((1:4))     # 1~4の乱数(1:left, 2:right, 3:up, 4:down)
    if direction == 1
        nv = left(v, field)
        move = 'L'
    elseif direction == 2
        nv = right(v, field)
        move = 'R'
    elseif direction == 3
        nv = up(v, field)
        move = 'U'
    elseif direction == 4
        nv = down(v, field)
        move = 'D'
    else
        println("move random tile error")
        exit()
    end
    return move
end

function direct_char(field::Field, c::Char)::Int
    v = field.zero_vertex
    if c == 'L'
        return left(v, field)
    elseif c == 'R'
        return right(v, field)
    elseif c == 'U'
        return up(v, field)
    elseif c == 'D'
        return down(v, field)
    else
        println("Error: direct_char")
        exit()
    end
end


function simulated_annealing()
    # 計算時間
    time_limit = Millisecond(1_000)
    # 
end

"""
"""
function solve()
    maxiter = 1_000
    # 入力 ~ fieldの初期化
    N, T = parseListInt()
    init_field = [readline() for _ in 1:N]
    field = initialize_field(init_field, T)
    find_zero!(field)
    # ゴールとなる盤面(field)を作成する．
    tmp_score = calc_score(field)
    tmp_field = copy(field)
    for i in 1:maxiter
        shuffle!(tmp_field.field)
        now_score = calc_score(tmp_field)
        if tmp_score < calc_score(tmp_field)   # スコアが良かったら更新する．
            tmp_score = now_score
        end
    end
    # A*アルゴリズムにより初期盤面から目標盤面へ移動させる．
    # その時の移動を記録する．

end

function test_calc_score()
    N, T = parseListInt()
    init_field = [readline() for _ = 1:N]
    field = initialize_field(init_field, T)
    # println(field.field)
    find_zero!(field)
    # println(field.field)
    # example = "RRRDLUULDDDDLUUUR"
    example = "RLUD"
    score = calc_score(field)
    # println(score)
    for c in example
        # println(c)
        v = field.zero_vertex
        # println(v)
        nv = direct_char(field, c)
        # println(nv)
        swap_tile!(field, v, nv)
        score = calc_score(field)
        println(score)
    end
    println(score)
    # println(field)
end


solve()
