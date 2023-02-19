# solver.jl
# Date: 2022/03/27

# Library ====
using Dates
using DataStructures

# Function Templete


# Const ====
DEBUG = true
TIME_LIMIT = Millisecond(1000) # Millisecond (1 second)
const Y = 20
const X = 20
DIRECT = ['U', 'D', 'L', 'R']
DIRECTIONS = Dict(
    'U' => [-1, 0], 
    'D' => [1, 0], 
    'L' => [0, -1], 
    'R' => [0, 1]
)

struct Wall
    h::Vector{String}    # 縦方向におく -> 横の移動(R, L)をさせない
    v::Vector{String}    # 横方向に置く -> 縦の移動(U, D)をさせない
end

mutable struct Human
    y::Int16
    x::Int16
end


function move(human::Human, wall::Wall, direction::String)
    flag, ny, nx = can_move(human, direction, wall)
    if flag
        human.y = ny
        human.x = nx
    end
end

function exist_wall(y::Int, x::Int, direction::Char, wall::Wall)::Bool
    # 移動方向は移動先の場外判定は行われている
    my, mx = DIRECTIONS[direction]
    ny = y + my
    nx = x + mx
    if ny <= 0 || Y < ny || nx <= 0 || X < nx   # 場外判定
        # println("Out of field")
        flag = false
        return flag
    end
    # 壁がある時 -> true
    flag = false    # 壁なし
    if direction == 'U' || direction == 'D'
        w = wall.v
        if direction == 'U' 
            if w[y-1][x] == '1'
                flag = true
            end
        elseif direction == 'D' 
            if w[y][x] == '1'
                flag = true
            end
        end
    elseif direction == 'L' || direction == 'R'
        w = wall.h
        if direction == 'R'
            if w[y][x] == '1'
                flag = true
            end
        elseif direction == 'L' 
            # println(x, mx, direction)
            if w[y][x-1] == '1'
                flag = true
            end
        end
    else
        error("No Direction")
    end
    return flag
end

function can_move(human::Human, wall::Wall, direction::Char)
    my, mx = DIRECTIONS[direction]
    ny = human.y + my
    nx = human.x + mx
    if ny <= 0 || Y < ny || nx <= 0 || X < nx   # 場外判定
        flag = false
    else
        if exist_wall(ny, nx, direction, wall)    # 壁判定
            flag = false
        else
            flag = true
        end
    end
    return flag, ny, nx
end

function can_move(y::Int, x::Int, wall::Wall, direction::Char)
    my, mx = DIRECTIONS[direction]
    ny = y + my
    nx = x + mx
    if ny <= 0 || Y < ny || nx <= 0 || X < nx   # 場外判定
        # println("Out of field")
        flag = false
    else
        if exist_wall(y, x, direction, wall)    # 壁判定
            # println("Wall")
            flag = false
        else
            flag = true
        end
    end
    return flag, ny, nx

end


"""
return: 
    p, sy, sx, gy, gx, human, wall
"""
function input()
    # 0 ≤ sy, sx ≤ 4, 15 ≤ ty, tx ≤ 19
    # 1 ≤ gy, gx ≤ 5, 16 ≤ gy, gx ≤ 20 (in Julia)
    # p: 各文字を忘れてしまう確率. 0.1 ≤ p ≤ 0.5
    sy, sx, gy, gx, p = parse.(Float64, split(readline()))
    sy = Int16(sy) + 1
    sx = Int16(sx) + 1
    gy = Int16(gy) + 1
    gx = Int16(gx) + 1
    h = [readline() for _ in 1:20]
    v = [readline() for _ in 1:19]
    wall = Wall(h, v)
    human = Human(sy, sx)
    return p, sy, sx, gy, gx, human, wall
end

function output(ans::String)
    println(ans)
end

function simulated_annealing(
        p::Float64, sy::Int, sx::Int, gy::Int, gx::Int,
        human::Human, wall::Wall
        )::String
    now_path = init_path(sy, sx, gy, gx, human, wall)
    now_score = calc_score(now_path, p, sy, sx, gy, gx, human, wall)
    start_temp = 0
    end_temp = 0
    start_time = Time(now())
    # DEBUG && println("now_score: ", now_score)
    while (true)
        now_time = Time(now())
        diff_time = Millisecond(now_time - start_time)
        if diff_time > TIME_LIMIT   # 時間制限
            DEBUG && println(diff_time)
            break
        end
        new_path = modify_path(now_path)
        new_score = calc_score(new_path, p, sy, sx, gy, gx, human, wall)
        println("new_score: ", new_score)
        # DEBUG && println(new_score)
        if new_score > now_score
            DEBUG && println("update")
            # 状態の更新
            now_path = new_path
            new_score = now_score
        else
            # 温度関数
            temp = start_temp + (end_temp - start_temp)*(diff_time)/TIME_LIMIT
            prob = exp((new_score - now_score)/temp)    # 更新確率
            if prob > rand()
                DEBUG && println("prob update")
                # 状態の更新
                now_path = new_path
                now_score = new_score
            end
        end
    end
    return now_path
end

function init_path(
        sy::Int, sx::Int, gy::Int, gx::Int,
        human::Human, wall::Wall
    )::String
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
            if !can_move(y, x, wall, d)[1] # 動けない時
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
    # println(maximum(dist))
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
    # 忘れ対策として，全部2倍する
    path = path ^ 3
    return path
end

function modify_path(path::String)::String
    # 
    if length(path) >= 200
        # drop
        idx = rand(1:length(path))
        new_path = path[1:idx-1] * path[idx+1:end]
    else
        # 適当な位置に "U", "D", "L", "R" を追加する
        idx = rand(1:length(path))
        s = DIRECT[rand(1:4)]
        new_path = path[1:idx] * s * path[idx+1:end]
    end
    return new_path
end


function calc_score(
        path::String, p::Float64, 
        sy::Int, sx::Int, gy::Int, gx::Int, 
        human::Human, wall::Wall
    )::Float64

    score = 0.0
    old_field = zeros(Y, X)
    old_field[sy, sx] = 1.0     # t = 0(開始時点)
    now_field = zeros(Y, X)   # t = tᵢ
    now_time = 0
    println(path)
    for s in path
        now_time += 1
        # 移動先のマスを得る
        py = 0
        px = 0
        if s == 'U'
            py = -1
        elseif s == 'D'
            py = 1
        elseif s == 'L'
            px = -1
        else    # 'R'
            px = 1
        end
        for y in 1:Y
            for x in 1:X
                # 最初から移動できない時
                if y + py <= 0 || Y < y + py || x + px <= 0 || X < x + px
                    now_field[y, x] = old_field[y, x]
                elseif can_move(y, x, wall, s)[1]   # 移動できる時
                    now_field[y+py, x+px] = old_field[y, x] * (1-p)
                    now_field[y, x] = old_field[y, x] * p
                else 
                    now_field[y, x] = old_field[y, x]
                end
            end
        end
        # println("goal: ", now_field[gy, gx])
        @show now_field
        # println("sum field: ", sum(now_field))
        score += (now_field[gy, gx] * (401 - now_time))*250_000
        # println(score)
        old_field = deepcopy(now_field)
        now_field = zeros(Y, X)
    end
    if score < 0.1
        score = 2.0
    end
    return score
end

function main()
    p, sy, sx, gy, gx, human, wall = input()
    ans = simulated_annealing(p, sy, sx, gy, gx, human, wall)
    output(ans)
end

main()