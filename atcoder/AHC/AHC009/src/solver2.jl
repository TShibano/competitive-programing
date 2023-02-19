# solver2.jl
# Date: 2022/04/01
# update ====
# - 複合型`Coord`をやめた
# - 初期値の3倍はTLEしたのでなし．
# - その代わり焼きなまし法が終わった後に，200文字になるまで文字を増やしてみる．

# Library ====
using Random            # 
using Dates             # To measure time
using DataStructures    # To use Deque
Random.seed!(0)

# Const ====
TIME_LIMIT = Millisecond(750) # 0.75sec
const Y = 20
const X = 20
DIRECT = ['U', 'D', 'L', 'R']
DIRECTIONS = Dict('U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1]) # [y, x]

# global variable ====

# Conposite type ====
struct Wall
    h::Vector{String}       # 縦方向に置く -> 横移動　(R, L)をさせない
    v::Vector{String}       # 横方向に置く -> 縦移動(U, D)をさせない
end

# Body ====
function input()
    # 0 ≤ sy, sx ≤ 4, 15 ≤ ty, tx ≤ 19
    # 1 ≤ gy, gx ≤ 5, 16 ≤ gy, gx ≤ 20 (in Julia)
    # p: 各文字を忘れてしまう確率. 0.1 ≤ p ≤ 0.5
    sy, sx, gy, gx, p = parse.(Float64, split(readline()))
    sy = Int8(sy) + 1
    sx = Int8(sx) + 1
    gy = Int8(gy) + 1
    gx = Int8(gx) + 1
    h = [readline() for _ in 1:20]
    v = [readline() for _ in 1:19]
    wall = Wall(h, v)
    move_check_list = Array{Bool, 3}(undef, Y, X, 4)    # (Y, X, d)
    move_check_list = init_can_move(wall)
    return p, sy, sx, gy, gx, move_check_list
end

function simulated_annealing(p::Float64, sy, sx, gy, gx, move_check_list)::String
    now_path = init_path(sy, sx, gy, gx, move_check_list)
    now_score = calc_score(now_path, p, sy, sx, gy, gx, move_check_list)
    start_temp = 0
    end_temp = 0
    start_time = Time(now())
    iters = 0
    while true
        iters += 1
        # 制限時間
        now_time = Time(now())
        diff_time = Millisecond(now_time - start_time)
        if diff_time > TIME_LIMIT
            break
        end
        new_path = modify_path(now_path)
        new_score = calc_score(new_path, p, sy, sx, gy, gx, move_check_list)
        # println("new score: ", new_score)
        if new_score >= now_score
            now_path = new_path
            new_score = now_score
        else
            # 温度関数
            temp = start_temp + (end_temp - start_temp)*diff_time/TIME_LIMIT
            prob = exp((new_score - now_score)/temp)    # 更新確率
            if prob > rand()
                now_path = new_path
                now_score = new_score
            end
        end
    end
    # println("iters: ", iters)
    # 200字まで文字をくっつける
    # println(now_path)
    if length(now_path) < 200
        num = 200 -length(now_path)
        for i in 1:num
            idx = Random.rand(1:length(now_path))
            s = DIRECT[rand(1:4)]
            now_path = now_path[1:idx] * s * now_path[idx+1:end]
        end
    end
    return now_path
end

## functions for moving
"""
毎回移動できるかの判定を行うのは処理が重くなるで，移動の有無を決めた配列を最初に作成する．
"""
function init_can_move(wall)
    move_check_list = Array{Bool, 3}(undef, Y, X, 4)
    for y in 1:20
        for x in 1:20
            for (idx, d) in enumerate(['U', 'D', 'L', 'R'])
                if _can_move(y, x, d, wall)
                    move_check_list[y, x, idx] = true
                else
                    move_check_list[y, x, idx] = false
                end
            end
        end
    end
    return move_check_list
end

function _can_move(y::Int, x::Int, direction::Char, wall::Wall)::Bool
    ny = y + DIRECTIONS[direction][1]
    nx = x + DIRECTIONS[direction][2]
    # 場外判定
    if ny < 1 || Y < ny || nx < 1 || X < nx
        return false
    end
    # 壁の判定
    if exist_wall(y, x, direction, wall)
        return false
    end
    return true
end

"""
移動先に壁があるかの判定
"""
function exist_wall(y::Int, x::Int, direction::Char, wall::Wall)::Bool
    # 上下に移動する -> wall.v 
    # 左右に移動する　 -> wall.h
    if direction == 'U'
        w = wall.v
        if w[y-1][x] == '1'
            return true
        end
    elseif direction == 'D'
        w = wall.v
        if w[y][x] == '1'
            return true
        end
    elseif direction == 'L'
        w = wall.h
        if w[y][x-1] == '1'
            return true
        end
    elseif direction == 'R' 
        w = wall.h
        if w[y][x] == '1'
            return true
        end
    else
        throw(DomainError(direction, "U or D or L or R"))
    end
    return false    # 壁でない時
end

function can_move(y::Int, x::Int, direction::Char, move_check_list)::Bool
    if direction == 'U'
        return move_check_list[y, x, 1]
    elseif direction == 'D'
        return move_check_list[y, x, 2]
    elseif direction == 'L'
        return move_check_list[y, x, 3]
    elseif direction == 'R'
        return move_check_list[y, x, 4]
    else
        throw(DomainError(direction, "U or D or L or R"))
    end
end



## functions for simulated annealing ====

"""
焼きなまし法で用いる初期値を計算する．
今回はBFSを用いた
"""
function init_path(sy::Int, sx::Int, gy::Int, gx::Int, move_check_list)::String
    dist = fill(-1, 20, 20)
    que = Deque{Array{Int, 1}}()
    # 初期条件
    dist[sy, sx] = 0
    push!(que, [sy, sx])
    # 探索中にきたマスを覚える
    prev_y = fill(-1, 20, 20)
    prev_x = fill(-1, 20, 20)
    while !isempty(que)
        # println(que)
        y, x = popfirst!(que)
        for d in DIRECT
            if !can_move(y, x, d, move_check_list) # 動けない時
                continue
            end
            ny = y + DIRECTIONS[d][1]
            nx = x + DIRECTIONS[d][2]
            # println(ny, nx)
            if dist[ny, nx] != -1       # すでに到達している時
                continue
            end
            # 新たな頂点について
            dist[ny, nx] = dist[y, x] + 1
            push!(que, [ny, nx])
            # 頂点の記録
            prev_y[ny, nx] = y
            prev_x[ny, nx] = x
        end
    end
    # println(dist)
    # 経路復元
    path = ""
    y = gy
    x = gx
    while y != -1 && x != -1
        # 前の頂点に行く
        py = prev_y[y, x]
        px = prev_x[y, x]
        # println(py, px)
        if py == -1 && px == -1
            break
        end
        # 今の頂点と手間の頂点の関係性を見て経路を復元する．
        if y == py && x == px-1
            path = "L" * path
        elseif  y == py && x == px+1
            path = "R" * path
        elseif y == py-1 && x == px
            path = "U" * path
        elseif y == py+1 && x == px
            path = "D" * path
        else
            # println("BAG!")
            exit()
        end
        y, x = py, px
        # println(length(path))
    end
    # 忘れ対策として，全部3倍する
    path = path ^ 2
    # println("init_path: ", path)
    return path
end

"""
焼きなまし法で用いる答えの探索
"""
function modify_path(path::String)::String
    if length(path) >= 200
        # 200文字以上はWAであるため削る
        idx = Random.rand(1:length(path))
        new_path = path[1:idx-1]*path[idx+1:end]
    else
        # 適当な位置に'U', 'D', 'L', 'R'を追加する
        idx = Random.rand(1:length(path))
        s = DIRECT[rand(1:4)]
        new_path = path[1:idx] * s * path[idx+1:end]
    end
    return new_path
end

"""
スコア計算．
移動するごとに各マスに存在する確率を計算し，
sum(round(ゴール地点にいる確率 * (401-現在の時間)))
をスコアとする．
"""
function calc_score(path::String, p::Float64, sy::Int, sx::Int, gy::Int, gx::Int, move_check_list)::Float64
    score = 0.0
    old_field = zeros(Y, X)
    old_field[sy, sx] = 1.0   # 初期条件
    now_field = zeros(Y, X)
    now_time::Int = 0
    for s in path
        now_time += 1
        # 移動方向を得る
        py, px = 0, 0
        if s == 'U'
            py = -1
        elseif s == 'D'
            py = 1
        elseif s == 'L'
            px = -1
        elseif s == 'R'
            px = 1
        else
            throw(DomainError(s, "s is U/D/L/R."))
        end
        for y in 1:Y
            for x in 1:X
                # if y+py < 1 || Y < y+py || x+px < 1 || X < x+px
                    # 場外に行こうとする時 = 覚えていても忘れても場所は固定される
                    # now_field[y, x] = old_field[y, x]
                if can_move(y, x, s, move_check_list)   # 移動できる時
                    now_field[y+py, x+px] += old_field[y, x] * (1-p)     # 覚えていて進む
                    now_field[y, x] += old_field[y, x] * p               # 忘れて留まる
                else    # 移動できない時
                    now_field[y, x] += old_field[y, x]
                end
            end
        end
        # @show sum(now_field)
        if now_time > 200
            score = 0.0
            break
        end
        score += (now_field[gy, gx] * (401-now_time))
        old_field = deepcopy(now_field)
        old_field[gy, gx] = 0.0
        now_field = zeros(Y, X)
    end
    # println(round(score))
    return round(score*250_000)
end


# main ====
function main()
    p, sy, sx, gy, gx, move_check_list = input()
    ans = simulated_annealing(p, sy, sx, gy, gx, move_check_list)
    println(ans)
    # println(length(ans))
    # println(calc_score(ans, p, sy, sx, gy, gx, move_check_list))
end

# @time main()
main()