# StronglyConnectedComponent.jl
# 強連結成分分解
# 有向グラフにおいて，互いに行ったり来たり出来るノードの塊に分けること．
# 計算量O(V+E) V: ノードの数, E: 辺の数
# 参考URL: https://tjkendev.github.io/procon-library/python/graph/scc.html
# 順方向と逆方向のグラフを用意して，最初に順方向でDFS，次に逆方向で開始位置に注意してDFS


function scc(N, G, RG)
    # 強連結成分分解を行う
    # ラベルの数とグループ分けの結果を返す
    order = Vector{Int32}()
    group = fill(-1, N)

    function dfs(s)
        used[s] = true
        for t in G[s]
            !used[t] && dfs(t)
        end
        push!(order, s)
    end

    function rdfs(s, col)
        group[s] = col
        used[s] = true
        for t in RG[s]
            !used[t]  && rdfs(t, col)
        end
    end

    used = falses(N)
    for i in 1:N
        !used[i] && dfs(i)
    end
    used = falses(N)
    label = 1
    for s in reverse!(order)
        if !used[s]
            rdfs(s, label)
            label += 1
        end
    end
    return (label-1, group)
end

function construct(N, G, label, group)
    # 強連結の部分をまとめた(縮約した)グラフを構築する
    G0 = [Set() for _ in 1:N]
    GP = [[] for _ in 1:N]
    for v in 1:N
        lbs = group[v]
        for w in G[v]
            lbt = group[w]
            if lbs == lbt
                continue
            end
            push!(G0[lbs], lbt)
        end
        push!(GP[lbs], v)
    end
    return (G0, GP)
end

function main()
    # グラフの入力
    # 強連結成分分解のために逆向きグラフも作成する
    N, M = parseMap()
    graph = Array{Vector{Int32}, 1}()
    rgraph = Array{Vector{Int32}, 1}()
    for _ in 1:N
        push!(graph, [])
        push!(rgraph, [])
    end
    for _ in 1:M
        A, B = parseMap()
        push!(graph[A], B)
        push!(rgraph[B], A)
    end
    labels, groups = scc(N, graph, rgraph)
    #@show labels
    #@show groups
    group_count = fill(0, labels)
    for i in 1:N
        group_count[groups[i]] += 1
    end
    ans = 0
    for i in 1:labels
        ans += group_count[i] * (group_count[i]-1) ÷ 2
    end
    println(ans)
    #GP = construct(N, graph, labels, groups)[2]
    #@show G0
    #@show GP
    #=
    ans = 0
    for _ in 1:N
        tmp = pop!(GP)
        !isempty(tmp) && (ans += length(tmp) * (length(tmp)-1) ÷ 2)
    end
    println(ans)
    =#


