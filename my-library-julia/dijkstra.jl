# Dijkstra.jl
# 単一始点最短経路問題
#  = ある一つの頂点から他の全ての頂点への最短経路を求める
#  優先度付きキューを用いて実装する

using DataStructures

parseMap(str=readline()) = parse.(Int, split(str))
parseInt(str=readline()) = parse(Int, str)

const INF = 10^14

mutable struct Edge
    # to: 行先
    # cost: 経路
    to::Int
    cost::Int
end
Graph = Vector{Vector{Edge}}

function input(N::Int, M::Int)::Array{Array{Edge, 1}, 1}
    # グラフの準備
    # N: 頂点の数，M: 辺の数
    graph = Array{Array{Edge, 1}, 1}()    # 二重配列．[[Edge]; v1, [Edge]; v2, ...]のようになる
    for _ in 1:N
        push!(graph, Array{Edge, 1}())
    end
    # 辺を張る
    for _ in 1:M
        a, b, c = parseMap()
        push!(graph[a], Edge(b, c))
        push!(graph[b], Edge(a, c))
    end
    return graph
end
   

function dijkstra(graph::Graph, s::Int, N::Int)::Vector{Int}
    # graph: グラフ, s: 開始する頂点, N: 頂点の数
    # Dijkstra 
    prev = fill(-1, N)      # 経路復元
    dist = fill(INF, N)
    pq = PriorityQueue{Int, Int}()
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
            if dist[edge.to] > dist[nv] + edge.cost    # 最短距離候補ならpqに追加
                dist[edge.to] = dist[nv] + edge.cost
                pq[edge.to] = dist[edge.to]
                prev[edge.to] = nv      # 経路復元
            end
        end
    end
    return dist
end

function exmaple()
    # https://atcoder.jp/contests/typical90/tasks/typical90_m
    N, M = parseMap()
    graph = input(N, M)
    dist1 = dijkstra(graph, 1, N)
    distN = dijkstra(graph, N, N)
    for i = 1:N
        println(dist1[i] + distN[i])
    end
end

example()
