# prim.jl
#! きちんとまとめる必要あり．

# library ====
# using Primes
using DataStructures

# templete type ====
struct Edge
    no::Int # 橋の番号
    to::Int     # 行き先
    cost::Int   # コスト，距離
end
Graph = Vector{Vector{Edge}}

# templete function ====
parseListInt(str=readline()) = parse.(Int, split(str))
parseInt(str=readline()) = parse(Int, str)

# const ====
const INF = 10^10

# body ====
"""
    prim(V::Int, graph::Graph)
prim法
params:
    V: 頂点数
    graph: 隣接行列によるグラフ．(辺が存在しない場合はINF)
return:
    Tuple: 最小コストと用いた橋の番号
"""
function prim(V::Int, graph::Graph)::Tuple{Int, Vector{Int}}
    # mincost = fill(INF, V)        # 集合Xからの辺の最小コスト
    used = fill(false, V)          # 頂点iがXに含まれるか
    used_cnt = 0

    # 初期の頂点は 1 とする
    # mincost[1] = 0
    used[1] = true
    used_cnt += 1
    pq = PriorityQueue{Vector{Int}, Int}()
    for i in 1:length(graph[1])
        no, nv, nc = graph[1][i].no, graph[1][i].to, graph[1][i].cost
        pq[[no, nv]] = nc
    end
    total_cost = 0
    ans = Vector{Int}()     # 用いた橋の番号
    while used_cnt < V
        # 最小の重みの辺をpriority queueで取り出す．
        bridge, nc = peek(pq)       # bridge: 橋情報 / nc: 距離
        no, nv = bridge             # no: 橋の番号 / nv: 頂点
        dequeue!(pq)

        if used[nv]     # すでに使われている．
            continue
        end
        # 頂点 nv を使用済みにする
        used[nv] = true
        used_cnt += 1
        total_cost += nc
        push!(ans, no)

        # 頂点 nv に隣接する
        for edge in graph[nv]
            no, nv, nc = edge.no, edge.to, edge.cost
            used[nv] || (pq[[no, nv]] = nc)       # マークされていないなら，追加する
        end
    end
    return (total_cost, ans)
end

function solve()
    # input ====
    N, M = parseListInt()
    graph = Graph()
    for _ in 1:N
        push!(graph, Vector{Edge}())
    end
    @inbounds for i in 1:M
        a, b, c = parseListInt()
        push!(graph[a], Edge(i, b, c))
        push!(graph[b], Edge(i, a, c))
    end
    total_cost, ans = prim(N, graph)
    # println(ans)
    join(stdout, ans, " ")
    print("\n")
end


solve()
