# AHC017-A
using Random
using DataStructures: PriorityQueue, dequeue!, peek

#const LOCAL = false
const LOCAL = true
const INF = 10^9
Random.seed!(0)


"""入力"""
struct Input
    N::Int64
    M::Int64
    D::Int64
    K::Int64
    es::Vector{Vector{Int64}}
end

"""結果を格納するための構造体"""
struct Output
    ans::Vector{Int64}
end

"""グラフの辺の情報"""
struct Edge
    to::Int64
    d::Int64
end

struct EdgeInfo
    id::Int64
    u::Int64
    v::Int64
    d::Int64
end


parse_list_int(str=readline()) = parse.(Int64, split(str))

"""隣接リストでグラフを持つ"""
Graph = Vector{Vector{Edge}}

# 入出力関連 ====
"""システムテスト用の入力"""
function parser_input_tester()::Input
    N, M, D, K = parse_list_int()
    es = [Int64[] for _ in 1:M]
    for i in 1:M
        es[i] = parse_list_int()
    end
    for _ in 1:N
        _, _ = parse_list_int()
    end
    return Input(N, M, D, K, es)
end

"""システム用の出力"""
function parser_output_tester(output::Output)::Nothing
    join(stdout, output.ans, " ")
    print("\n")
end

"""ローカルテスト用の入力"""
function parser_input_local()
    f = open(ARGS[1], "r")
    N, M, D, K = parse_list_int(readline(f))
    es = [Int64[] for _ in 1:M]
    for i in 1:M
        es[i] = parse_list_int(readline(f))
    end
    for _ in 1:N
        _, _ = parse_list_int(readline(f))
    end
    return Input(N, M, D, K, es)
end


"""ローカル用の出力"""
function parser_output_local(output::Output)::Nothing
    open(ARGS[2], "w") do out
        join(out, output.ans, " ")
        print("\n")
    end
end

# グラフ処理 ====
"""辺の情報を取得する"""
function get_edge_info(input::Input)::Vector{EdgeInfo}
    edge_list = Vector{EdgeInfo}(undef, input.M)
    for i in 1:input.M
        u, v, w = input.es[i]
        edge_list[i] = EdgeInfo(i, u, v, w)
    end
    return edge_list
end


"""グラフの読み込み
input: テストケースの入力
output: 答えを格納した配列(0日目の場合は空の配列を渡す)
day: 何日目のグラフを得るか．0日目の場合はどの辺も工事していない場合にあたる
"""
function get_graph(
        input::Input;
        output::Union{Output, Nothing}=nothing,
        day::Int64=0)::Graph
    graph = Graph()
    for _ in 1:input.N
        push!(graph, Vector{Edge}())
    end
    if day == 0
        for i in 1:input.M
            u, v, d = input.es[i]
            push!(graph[u], Edge(v, d))
            push!(graph[v], Edge(u, d))
        end
    else
        for i in 1:input.M
            if output.ans[i] != day # 辺が除外する日以外なら読み込む
                u, v, d = input.es[i]
                push!(graph[u], Edge(v, d))
                push!(graph[v], Edge(u, d))
            end
        end
    end
    return graph
end

# ダイクストラを各頂点で行う
# ダイクストラの計算量は，(E+V)logVなので全頂点する場合，V(E+V)logVであり，
# 最大でも，1000 * (3000 + 1000)log(1000) = 1000 * 4000 * k = 10^7程度なので問題なし
"""ダイクストラ法である点からそれ以外の全点の距離を求める
graph: グラフ
s: 開始する頂点
"""
function dijkstra(graph::Graph, s::Int64)::Vector{Int64}
    # graph: グラフ, s: 開始する頂点, N: 頂点の数
    dist = fill(INF, length(graph))
    pq = PriorityQueue{Int64, Int64}()
    # 開始ノード
    dist[s] = 0    # 開始ノードは0
    pq[s] = 0    # 開始ノードの距離は0なので，0を入れる
    while !isempty(pq)
        # 最小の重みの辺をとりだす
        nv, nc = peek(pq)    # nv: 次に見る頂点，nc: その頂点との距離(cost)
        dequeue!(pq)
        (dist[nv] < nc) && continue    # 最短距離でなければ無視
        for i in 1:length(graph[nv])
            edge = graph[nv][i]
            if dist[edge.to] > dist[nv] + edge.d    # 最短距離候補ならpqに追加
                dist[edge.to] = dist[nv] + edge.d
                pq[edge.to] = dist[edge.to]
            end
        end
    end
    return dist
end

# 全点に対して求める
"""全点対の距離をダイクストラ繰り返しを使って求める"""
function repeat_dijkstra(graph::Graph)::Vector{Vector{Int64}}
    dist_list = Vector{Vector{Int64}}()
    for s in 1:length(graph)
        push!(dist_list, dijkstra(graph, s))
    end
    return dist_list
end

"""ある日の全点対距離リストを求める
input: テストケースの入力
output: 答えを格納した配列(0日目の場合は空の配列を渡す)
day: 何日目のグラフを得るか．0日目の場合はどの辺も工事していない場合にあたる
"""
function compute_dist_lsit_one_day(
        input::Input;
        output::Union{Output, Nothing}=nothing,
        day::Int64=0)::Vector{Vector{Int64}}
    graph = get_graph(input, output=output, day=day)
    return repeat_dijkstra(graph)
end

"""二つの全点対距離リストからスコアを計算する
dist_list: 工事開始後の全点対距離リスト
base_dist_list: 工事開始前の全点対距離リスト
"""
function compute_score_one_day(
        dist_list::Vector{Vector{Int64}}, 
        base_dist_list::Vector{Vector{Int64}})::Float64
    N = length(dist_list[1])
    score = 0
    for i = 1:N
        for j = (i+1):N
            score += (dist_list[i][j] - base_dist_list[i][j])
        end
    end
    score_one_day = 2 * score / (N * (N-1))
    return score_one_day
end

"""入力と出力を与えてトータルスコアを計算する
"""
function compute_total_score(input::Input, output::Output)::Int64
    base_dist_list = compute_dist_lsit_one_day(input)
    score = 0.0
    for d in 1:input.D
        dist_list = compute_dist_lsit_one_day(input, output=output, day=d)
        score += compute_score_one_day(dist_list, base_dist_list)
    end
    score = 1000 * (score / input.D)
    #println(score)
    score = trunc(Int64, round(score))
    return score
end

"""指定した頂点だけダイクストラを行う"""
function repeat_dijkstra_part(graph::Graph, vs::Vector{Int64})::Vector{Vector{Int64}}
    dist_list = Vector{Vector{Int64}}(undef, length(graph))
    for i in 1:length(vs)
        dist_list[vs[i]] = dijkstra(graph, vs[i])
    end
    return dist_list
end

function compute_part_score(
        input::Input,
        output::Output,
        base_dist_list::Vector{Vector{Int64}},
        vs=Vector{Int64},
        day::Int64=0
        )::Int64
    graph = get_graph(input, output=output, day=day)
    dist_list = repeat_dijkstra_part(graph, vs)
    score = 0.0
    for i = 1:length(vs)
        for j = i+1:length(vs)
            score += dist_list[vs[i]][vs[j]] - base_dist_list[vs[i]][vs[j]]
        end
    end
    return score
end

# 解法コード ====

function calc_mean_days_list(input::Input)::Vector{Int64}
    d = input.M ÷ input.D
    days_list = fill(d, input.D)
    for i in 1:(input.M - d*input.D)
        days_list[i] += 1
    end
    return days_list
end


"""解法01
各日に工事する日程を与えて，工事する日程はランダムに決める
"""
function solve01(input::Input)::Output
    days_list = get_mean_days_list(input)
    ans_list = zeros(Int64, input.M)
    day = 1
    m = 1
    for d in days_list
        for _ in 1:d
            ans_list[m] = day
            m += 1
        end
        day += 1
    end
    shuffle!(ans_list)
    return Output(ans_list)
end


"""解法1
頂点に関して，1日に工事する辺を極力1本にする方法
"""
function solve1(input::Input)::Output
    days_list = calc_mean_days_list(input)
    edge_list = get_edge_info(input)
    ans_edge_list = zeros(Int64, input.M)
    edge_index = collect(1:input.M)
    for day in 1:input.D
        #shuffle!(edge_index)    # 毎回シャッフルする
        one_day_edge = days_list[day]   # 今日工事する辺の数
        cnt_now_edge = 0        # 今工事した辺の数
        check_vertex = falses(input.N)    # 工事した頂点かどうかを判断する
        # 辺を順番に取り出す
        for e in edge_index
            if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
                break
            end
            if ans_edge_list[e] != 0
                continue
            else
                # まだ工事していない辺なので情報を取り出す
                edge = edge_list[e]
                u, v= edge.u, edge.v
                if !check_vertex[u] && !check_vertex[v]
                    # まだ選ばれていない頂点の場合，工事する
                    ans_edge_list[e] = day
                    check_vertex[u] = true
                    check_vertex[v] = true
                    cnt_now_edge += 1
                    continue
                else
                    continue
                end
            end
        end
        if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
            continue
        end
        # まだ工事枠が余っている場合
        for e in edge_index
            if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
                break
            end
            if ans_edge_list[e] != 0
                continue
            else
                # 辺の情報を取り出す
                edge = edge_list[e]
                u, v = edge.u, edge.v
                if !check_vertex[u] || !check_vertex[v]
                    # まだ選ばれていない頂点の場合，工事する
                    ans_edge_list[e] = day
                    check_vertex[u] = true
                    check_vertex[v] = true
                    cnt_now_edge += 1
                    continue
                else
                    continue
                end
            end
            if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
                break
            end
        end
        if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
            continue
        end
        for e in edge_index
            # まだ工事枠が余っている場合，工事を行う
            if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
                break
            end
            if ans_edge_list[e] != 0
                continue
            else
                # 辺の情報を取り出す
                edge = edge_list[e]
                u, v = edge.u, edge.v
                ans_edge_list[e] = day
                check_vertex[u] = true
                check_vertex[v] = true
                cnt_now_edge += 1
                continue
            end
            if one_day_edge == cnt_now_edge # 1日の工事上限数に達した場合
                break
            end
        end
    end
    return Output(ans_edge_list)
end

"""
solve1()のままでは，最後の日程に同じ頂点から複数辺が出ることになる
最終日で複数辺が出ている頂点を探し，他の日程と辺を交換する
-> これが本当に悪いかは不明
"""
function solve12(input::Input)::Output
    output = solve1(input)

    return Output(ans_list)
end


function swap(
        vec::Vector{Int64},
        d1::Int64,
        d2::Int64,
        n::Int64)::Vector{Int64}
    ret_vec = copy(vec)
    # 工事する日程を格納した配列から，day1, day2の日程を抜き出す
    idx_list1 = findall(vec .== d1)
    idx_list2 = findall(vec .== d2)
    # 重複なしサンプリングができないので，配列をシャッフルして先頭からとる
    shuffle!(idx_list1)
    shuffle!(idx_list2)
    idx1 = idx_list1[1:n]
    idx2 = idx_list2[1:n]
    for id in idx1
        ret_vec[id] = d2
    end
    for id in idx2
        ret_vec[id] = d1
    end
    return ret_vec
end


function solve11(input::Input)::Output
    t = 1.0     # 時間．多めに見積もっている
    output = solve1(input)
    ans = output.ans
    base_dist_list = compute_dist_lsit_one_day(input)
    vs = rand(1:input.N, 100)
    score_list = zeros(Int64, input.D)
    score_list, dt = @timed [compute_part_score(
            input,
            output,
            base_dist_list,
            vs,
            d) for d in 1:input.D]
    est_total_score = sum(score_list)
    t += dt
    n = trunc(Int64, (input.M ÷ input.D) * 0.1)
    while t < 4.0
        # 最大と最小の部分でスワップする
        tmp_score_list = copy(score_list)
        d1 = argmin(tmp_score_list)
        d2 = rand() > 0 ? input.D : argmax(tmp_score_list)
        tmp_ans = swap(ans, d1, d2, n)
        tmp_est_score1, dt = @timed compute_part_score(input, Output(tmp_ans), base_dist_list, vs, d1)
        tmp_est_score2 = compute_part_score(input, Output(tmp_ans), base_dist_list, vs, d2)
        t += 3*dt
        tmp_score_list[d1] = tmp_est_score1
        tmp_score_list[d2] = tmp_est_score2
        tmp_est_total_score = sum(tmp_score_list)
        if est_total_score > tmp_est_total_score
            ans = tmp_ans
            est_total_score = tmp_est_total_score
            score_list = copy(tmp_score_list)
        end
    end
    return Output(ans)
end

"""繰り返しダイクストラを用いた方法
繰り返しダイクストラ法をどれくらい回せるか
ほとんど回せなさそう
"""
function solve3(input::Input)::Output
    days_list = zeros(Int64, input.D)
    sho = input.M ÷ input.K
    amari = input.M % input.K
    for i in 1:sho
        days_list[i] = input.K
    end
    days_list[sho+1] = amari
    ans_list = zeros(Int64, input.M)
    day = 1
    m = 1
    for d in days_list
        for _ in 1:d
            ans_list[m] = day
            m += 1
        end
        day += 1
    end
    shuffle!(ans_list)
    base_score, tt = @timed compute_total_score(input, Output(ans_list))
    while tt < 4
        tmp_ans_list = shuffle!(ans_list)
        tmp_score, rt = @timed compute_total_score(input, Output(tmp_ans_list))
        #println(rt)
        tt += rt
        if base_score < tmp_score
            base_score = tmp_score
        end
        ans_list = tmp_ans_list
        #println(tt, "\t", base_score)
        if tt + rt > 4 
            break
        end
    end
    return Output(ans_list)
end


function solve(input::Input)::Output
    return solve1(input)
end

function main()
    if LOCAL
        input = parser_input_local()
        output = solve(input)
        println(compute_total_score(input, output))
        parser_output_local(output)
    else
        input = parser_input_tester()
        output = solve(input)
        parser_output_tester(output)
    end
end

main()
