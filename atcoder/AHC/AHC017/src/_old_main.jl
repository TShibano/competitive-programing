# AHC017

const DEBUG = true
const INF = 10^9
using Random
Random.seed!(0)


struct Input
    N::Int64
    M::Int64
    D::Int64
    K::Int64
    us::Vector{Int64}
    vs::Vector{Int64}
    ws::Vector{Int64}
end

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

Graph = Vector{Vector{Edge}}   # ListGraph

"""1行空白明けデータの読み込み"""
parse_list_int(str=readline()) =  parse.(Int64, split(str))



# グラフの読み込み ====
"""グラフを隣接配列で読み込む"""
function read_adj_matrix(N, M)
    graph = fill(-1, N, N)
    edge_list = Vector{EdgeInfo}(undef, M)
    for i in 1:M
        u, v, w = parse_list_int()
        graph[u, v] = w
        graph[v, u] = w
        edge_list[i] =  EdgeInfo(i, u, v, w)
    end
    return graph, edge_list
end

"""グラフを隣接リストで読み込む"""
function read_adj_list(N, M)
    graph = Graph()
    for _ in 1:N
        push!(graph, Vector{Edge}())
    end
    edge_list = Vector{EdgeInfo}(undef, M)
    for i in 1:M
        u, v, w = parse_list_int()
        push!(graph[u], Edge(v, w))
        push!(graph[v], Edge(u, w))
        edge_list[i] = EdgeInfo(i, u, v, w)
    end
    return graph, edge_list
end

"""グラフ読み込み関数のラッパー"""
function wrapper_read_graph(N, M)
    # 隣接リストで読み込む
    return read_adj_list(N, M)
    # 隣接行列で読み込む
    #return read_adj_matrix(N, M)
end


"""システムテスト用の入力"""
function input1()
    N, M, D, K = parse_list_int()
    graph, edge_list = wrapper_read_graph(N, M)
    for _ in 1:N
        _, _ = parse_list_int()
    end
    return N, M, D, K, graph, edge_list
end

"""システムテスト用の出力"""
function output1(ans::Vector{Int64})::Nothing
    join(stdout, ans, " ")
    print("\n")
end


# ローカルテスト用 ====
"""ローカルテスト用の入力"""
function input_tester()
    f = open(ARGS[1], "r")
    N, M, D, K = parse_list_int(readline(f))
    # 隣接リストを読み込む
    graph = [[] for _ in 1:N]
    edge_list = Vector{Edge}(undef, M)
    for i in 1:M
        u, v, w = parse_list_int(readline(f))
        tmp_edge = Edge(i, w, u, v)
        push!(graph[u], tmp_edge)
        push!(graph[v], tmp_edge)
        edge_list[i] = tmp_edge
    end
    for _ in 1:N
        _, _ = parse_list_int(readline(f))
    end
    return N, M, D, K, graph, edge_list
end


"""ローカルテスト用にテキストファイルに結果を出力する"""
function output_to_txt(ans::Vector{Int64})::Nothing
    open(ARGS[2], "w") do out
        join(out, ans, " ")
        print("\n")
    end
end


# スコアを計算する関数====
# TODO: RustのコードをJuliaに移植する
# ダイクストラを各頂点で行う
# ダイクストラの計算量は，(E+V)logVなので全頂点する場合，V(E+V)logVであり，
# 最大でも，1000 * (3000 + 1000)log(1000) = 1000 * 4000 * k = 10^7程度なので問題なし
"""ダイクストラ法である点からそれ以外の全点の距離を求める"""
function dijkstra(graph::Graph, s::Int64, N::Int64)::Vector{Int64}
    # graph: グラフ, s: 開始する頂点, N: 頂点の数
    # Dijkstra 
    #prev = fill(-1, N)      # 経路復元
    dist = fill(INF, N)
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
                #prev[edge.to] = nv      # 経路復元
            end
        end
    end
    return dist
end

# 全点に対して求める
"""全点対の距離をダイクストラ繰り返しを使って求める"""
function calc_all_vertex_dist(graph::Graph, N::Int64)::Vector{Vector{Int64}}
    dist_list = Vector{Vector{Int64}}()
    for i in 1:N
        push!(dist_list, dijkstra(graph, i, N))
    end
    return dist_list
end


"""ある日のグラフを与えたときの不満度"""
function calc_score(tmp_dist_list, base_dist_list, N)
    score = 0
    for i in 1:N
        for j in i+1:N
            score = tmp_dist_list[i][j] - base_dist_list[i][j]
        end
    end
    return score/(N*(N-1))/2
end


# 解法 =====
function solve01(N, M, D, K, graph, edge_list)::Vector{Int64}
    # 1日に作業する辺の数: days_list
    d = M ÷ D
    days_list = fill(d, D)
    for i in 1:(M-d*D)
        days_list[i] += 1
    end
    #println(days_list)
    #sum(days_list) != M && error("1日に工事する個数がおかしい")
    ans_list = zeros(Int64, M)
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
    return ans_list
end

function solve02(N, M, D, K, graph, edge_list)::Vector{Int64}
    # 1日に作業する辺の数: days_list
    # 初日から限界まで工事する
    days_list = zeros(Int64, D)
    sho = M ÷ K
    amari = M % K
    days_list = zeros(Int64, D)
    for i in 1:sho
        days_list[i] = K
    end
    days_list[sho+1] = amari
    ans_list = zeros(Int64, M)
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
    return ans_list
end




function solve1(N, M, D, K, graph, edge_list)
    #TODO
    # 各日に工事する橋の数(solve02)
    sho = M ÷ K
    amari = M % K
    days_list = zeros(Int64, D)
    for i in 1:sho
        days_list[i] = K
    end
    days_list[sho+1] = amari

    # 1日に作業する辺の数: days_list
    #=
    d = M ÷ D
    days_list = fill(d, D)
    for i in 1:(M-d*D)
        days_list[i] += 1
    end
    =#

    ans_edge_list = zeros(Int64, M) # 工事する辺の日程を記録する配列
    for day in 1:D
        one_day_edge = days_list[day]   # 今日は工事する辺の数
        cnt_now_edge = 0        # 今工事した辺の数
        check_vertex = falses(N)    # 工事した頂点かどうかを判断する
        # 辺を順番に取り出す
        for e in 1:M
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
        for e in 1:M
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
        for e in 1:M
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
    return ans_edge_list
end

function solve(N, M, D, K, graph, edge_list)::Vector{Int64}
    return solve1(N, M, D, K, graph, edge_list)
end

function main()
    # input ====
    if DEBUG
        N, M, D, K, graph, edge_list = input_tester()
        ans_list = solve(N, M, D, K, graph, edge_list)
        output_to_txt(ans_list)
    else
        N, M, D, K, graph, edge_list = input1()
        ans_list = solve(N, M, D, K, graph, edge_list)
        output1(ans_list)
    end
end


main()
