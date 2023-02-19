# AHC - main.jl
# Date: 2022/11/11
# Version: 0.0.0
#== score memo
base:   150240563
n=20:   153371536
n=30:   102287486
n=40:   76851401, 
n=100:  30878100
==#
#== 考え方
M や ϵ が小さい時は，グラフを複雑にしなくてもよさそう
(そこまで大きくグラフが変形しない)
==#

# library ====
# using Statistics
# using Primes
# using DataStructures
using Random
Random.seed!(0)

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parseListFloat(str=readline()) = parse.(Float64, split(str))
parseInt(str=readline()) = parse(Int, str)

# composite types ====

# body ====

function input1()
    M, ϵ = split(readline())
    M = parse(Int, M)
    ϵ = parse(Float64, ϵ)
    return M, ϵ
end


"""
    pattern0(M::Int)

エラー率が0の時は辺が増減しないので，辺の数とグラフの順番を対応させておけば100%正解できる．
よって，要求グラフ数以上の変の数を持っておけばよい．

...
# Arguments
- `M::Int`: 要求グラフ数
...

"""
function solve_pattern0(M)
    # 頂点数を求める　
    N = 1
    while N*(N-1) < 2*M
        N += 1
    end
    println(N)  # 頂点の数
    total_node = N*(N-1)÷2
    # グラフの作成
    # 変の数を順番に増やしていく
    for m in 1:M
        tmp_graph = repeat("1", m) * repeat("0", total_node-m)
        println(tmp_graph)
    end
    # グラフを受け取り，予測値を出力する
    # 変の数(1)が正解のグラフ
    for _ in 1:100
        H = readline()
        cnt = count(==('1'), H)
        println(cnt-1)
    end
end



"""
    count_adj(H::String,N::Integer)::Vector{Integer}
本コンテストのグラフ表記から，各頂点の隣接頂点数を数える
...
# Arguments
- `H::String`: 
- `N::Integer::Vector{Integer}`: 
...

"""
function count_adj(graph, N)
    count_list = zeros(Int32, N) # 各頂点の隣接数をカウントする配列
    cnt = 0
    @inbounds for i in 1:N-1
        @inbounds for j in i+1:N
            cnt += 1
            if graph[cnt] == '1'
                count_list[i] += 1
                count_list[j] += 1
            end
        end
    end
    return count_list
end


function compute_hist_from_count_adj(num_vertex, adj_v_list)
    hist = zeros(Int32, num_vertex)
    for num in adj_v_list
        hist[num+1] += 1
    end
    return hist
end


function compute_hist(graph, num_vertex)
    count_list = count_adj(graph, num_vertex)
    return compute_hist_from_count_adj(num_vertex, count_list)
end

function calc_mse_hist(hist1, hist2)
    return sum((hist1 .- hist2).^2)
end


function predict_correct_graph(n_gens_graph, hist_gens1, hist_gens2, hist_input)
    ans = 1
    tmp_mse = 10^10
    for n in 1:n_gens_graph
        now_mse = calc_mse_hist(hist_gens1[n], hist_input)
        #now_mse += calc_mse_hist(hist_gens2[n], hist_input)
        if now_mse < tmp_mse
            ans = n
            tmp_mse = now_mse
        end
    end
    return ans-1
end


function generate_graph(N, M)
    # 1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100のグループを組み合わせて作る
    # 組み合わせ方は別途プログラムで作成し，配列として変数に入れておく
    graph_list = []
    all_group_list = [
			[[20, 5]],
			[[50, 2]],
			[[1, 100]],
			[[10, 10]],
			[[100, 1]],
			[[1, 10], [10, 9]],
			[[1, 10], [90, 1]],
			[[1, 70], [30, 1]],
			[[1, 50], [50, 1]],
			[[1, 90], [10, 1]],
			[[10, 1], [90, 1]],
			[[20, 1], [40, 2]],
			[[20, 1], [80, 1]],
			[[40, 1], [60, 1]],
			[[1, 30], [10, 1], [20, 3]],
			[[1, 10], [10, 7], [20, 1]],
			[[1, 10], [20, 1], [70, 1]],
			[[1, 10], [10, 1], [80, 1]],
			[[1, 10], [10, 1], [20, 1], [30, 2]],
			[[1, 10], [10, 1], [20, 2], [40, 1]],
			[[1, 10], [10, 1], [20, 1], [60, 1]],
			[[1, 10], [30, 3]],
			[[1, 50], [10, 5]],
			[[1, 60], [10, 4]],
			[[10, 2], [20, 4]],
			[[10, 4], [60, 1]],
			[[10, 5], [50, 1]],
			[[10, 6], [20, 2]],
			[[1, 60], [20, 2]],
			[[1, 60], [40, 1]],
			[[1, 70], [10, 3]],
			[[1, 80], [10, 2]],
			[[1, 80], [20, 1]],
			[[10, 1], [30, 3]],
			[[10, 6], [40, 1]],
			[[10, 7], [30, 1]],
			[[10, 8], [20, 1]],
			[[20, 2], [30, 2]],
			[[20, 2], [60, 1]],
			[[20, 3], [40, 1]],
			[[30, 1], [70, 1]],
			[[30, 2], [40, 1]],
			[[1, 10], [10, 1], [30, 1], [50, 1]],
			[[1, 10], [10, 2], [20, 1], [50, 1]],
			[[1, 10], [10, 1], [20, 4]],
			[[1, 10], [10, 1], [40, 2]],
			[[1, 10], [10, 2], [70, 1]],
			[[1, 10], [10, 3], [20, 3]],
			[[1, 10], [10, 3], [30, 2]],
			[[1, 10], [10, 3], [60, 1]],
			[[1, 10], [10, 4], [50, 1]],
			[[1, 20], [10, 2], [20, 3]],
			[[10, 2], [40, 2]],
			[[10, 2], [80, 1]],
			[[10, 3], [70, 1]],
			[[10, 4], [20, 3]],
			[[10, 4], [30, 2]],
			[[1, 20], [10, 2], [30, 2]],
			[[1, 20], [10, 2], [60, 1]],
			[[1, 20], [10, 3], [50, 1]],
			[[1, 20], [10, 4], [20, 2]],
			[[1, 20], [10, 4], [40, 1]],
			[[1, 70], [10, 1], [20, 1]],
			[[10, 1], [20, 1], [70, 1]],
			[[10, 1], [20, 2], [50, 1]],
			[[10, 1], [20, 3], [30, 1]],
			[[10, 1], [30, 1], [60, 1]],
			[[10, 1], [40, 1], [50, 1]],
			[[10, 2], [20, 1], [30, 2]],
			[[10, 2], [20, 1], [60, 1]],
			[[10, 2], [20, 2], [40, 1]],
			[[10, 2], [30, 1], [50, 1]],
			[[10, 3], [20, 1], [50, 1]],
			[[10, 3], [20, 2], [30, 1]],
			[[10, 3], [30, 1], [40, 1]],
			[[10, 4], [20, 1], [40, 1]],
			[[10, 5], [20, 1], [30, 1]],
			[[20, 1], [30, 1], [50, 1]],
			[[1, 10], [10, 2], [20, 2], [30, 1]],
			[[1, 10], [10, 2], [30, 1], [40, 1]],
			[[1, 10], [10, 3], [20, 1], [40, 1]],
			[[1, 10], [10, 4], [20, 1], [30, 1]],
			[[1, 10], [20, 1], [30, 1], [40, 1]],
			[[1, 20], [10, 1], [20, 1], [50, 1]],
			[[1, 20], [10, 1], [20, 2], [30, 1]],
			[[1, 20], [10, 1], [30, 1], [40, 1]],
			[[1, 20], [10, 2], [20, 1], [40, 1]],
			[[1, 20], [10, 3], [20, 1], [30, 1]],
			[[1, 30], [10, 1], [20, 1], [40, 1]],
			[[1, 30], [10, 2], [20, 1], [30, 1]],
			[[1, 40], [10, 1], [20, 1], [30, 1]],
			[[10, 1], [20, 1], [30, 1], [40, 1]],
			[[1, 20], [10, 8]],
			[[1, 20], [20, 4]],
			[[1, 20], [40, 2]],
			[[1, 20], [80, 1]],
			[[1, 30], [10, 7]],
			[[1, 30], [70, 1]],
			[[1, 40], [10, 6]],
			[[1, 40], [20, 3]],
			[[1, 40], [30, 2]],

			[[1, 40], [60, 1]],
			[[1, 10], [10, 5], [20, 2]],
			[[1, 10], [10, 5], [40, 1]],
			[[1, 10], [10, 6], [30, 1]],
			[[1, 10], [20, 2], [50, 1]],
			[[1, 10], [20, 3], [30, 1]],
			[[1, 10], [30, 1], [60, 1]],
			[[1, 10], [40, 1], [50, 1]],
			[[1, 20], [10, 1], [70, 1]],
			[[1, 20], [10, 5], [30, 1]],
			[[1, 20], [10, 6], [20, 1]],
			[[1, 20], [20, 1], [30, 2]],
			[[1, 20], [20, 1], [60, 1]],
			[[1, 20], [20, 2], [40, 1]],
			[[1, 20], [30, 1], [50, 1]],
			[[1, 30], [10, 1], [30, 2]],
			[[1, 30], [10, 1], [60, 1]],
			[[1, 30], [10, 2], [50, 1]],
			[[1, 30], [10, 3], [20, 2]],
			[[1, 30], [10, 3], [40, 1]],
			[[1, 30], [10, 4], [30, 1]],
			[[1, 30], [10, 5], [20, 1]],
			[[1, 30], [20, 1], [50, 1]],
			[[1, 30], [20, 2], [30, 1]],
			[[1, 30], [30, 1], [40, 1]],
			[[1, 40], [10, 1], [50, 1]],
			[[1, 40], [10, 2], [20, 2]],
			[[1, 40], [10, 2], [40, 1]],
			[[1, 40], [10, 3], [30, 1]],
			[[1, 40], [10, 4], [20, 1]],
			[[1, 40], [20, 1], [40, 1]],
			[[1, 50], [10, 1], [20, 2]],
			[[1, 50], [10, 1], [40, 1]],
			[[1, 50], [10, 2], [30, 1]],
			[[1, 50], [10, 3], [20, 1]],
			[[1, 50], [20, 1], [30, 1]],
			[[1, 60], [10, 1], [30, 1]],
			[[1, 60], [10, 2], [20, 1]],
    ]
    for m in 1:M
        group_list = all_group_list[m]
        tmp_graph = generate_graph_from_group_list(N, group_list)
        push!(graph_list, tmp_graph)
    end
    return graph_list
end

function generate_graph_from_group_list(N, lst)
    # 頂点の分割
    #   [ [グループ内の個数，グループの個数], [グループ内の個数，グループの個数], ... ]
    # という形で配列が格納されている
    # まず各頂点を所属するグループに分け，そこから今回のグラフ形式にする
    now_v = 1
    v_group_list = []
    for (n_in, n_group) in lst
        for group in 1:n_group
            tmp_group_list = []
            for in_group in 1:n_in
                push!(tmp_group_list, now_v)
                now_v += 1      # 頂点の更新
            end
            push!(v_group_list, tmp_group_list)
        end
    end
    # 所属するグループが決まったので，グラフを求める
    # "0"で初期化して，必要に応じて"1"に置き換える．
    graph = ['0' for _ in 1:N*(N-1)÷2]
    for now_group in v_group_list
        l = length(now_group)
        if l == 1
            continue
        end
        for i in 1:l-1
            for j in i+1:l
                vi = now_group[i]
                vj = now_group[j]
                idx = get_index(N, vi, vj)
                graph[idx] = '1'
            end
        end
    end
    return join(graph)
end


function get_index(N, vi, vj)
    main_pos = (vi-1)*N - vi*(vi-1)÷2 + 1
    sub_pos = vj-vi-1
    pos = main_pos + sub_pos
    return pos
end


function randomized_graph(graph, ϵ, total_node)
    lst_graph = collect(graph)
    for i in 1:length(total_node)
        if rand() < ϵ
            if lst_graph[i] == '1'
                lst_graph[i] = '0'
            else
                lst_graph[i] = '1'
            end
        end
    end
    return join(lst_graph)
end


function solve(M, ϵ)
    #=考え方
    グループ分けして，そのグループに属する頂点を全ての頂点を連結させる
    連結頂点数の組み合わせで元のグラフを判断させる
    元のグラフと今のグラフの隣接頂点数をカウントしたヒストグラムを使って最小二乗誤差が最も小さいグラフを選ぶ
    =#
    # 考えやすいように N = 100 とする
    N = 100
    println(N)
    total_node = N*(N-1)÷2
    # グラフの生成
    graph_list = generate_graph(N, M)
    # グラフの表示およびヒストグラムの作成
    hist_gens1 = []     # 生成したグラフの隣接頂点数をカウントしたヒストグラム
    hist_gens2 = []     # 生成したグラフの隣接頂点数をカウントしたヒストグラム
    for m in 1:M
        tmp_graph = graph_list[m]
        # グラフの表示 
        println(tmp_graph)
        # ヒストグラムの計算と保存
        push!(hist_gens1, compute_hist(tmp_graph, N))
        #=
        r_graph1 = randomized_graph(tmp_graph, ϵ, total_node)
        push!(hist_gens1, compute_hist(r_graph1, N))
        =#
        #=
        r_graph2 = randomized_graph(tmp_graph, ϵ, total_node)
        push!(hist_gens2, compute_hist(r_graph2, N))
        =#
    end
    n_gens_graph = length(hist_gens1)
    # 予測 ====
    for _ in 1:100
        H = readline()         # グラフの読み込み
        now_hist = compute_hist(H, N)       # ヒストグラムの生成
        ans = predict_correct_graph(n_gens_graph, hist_gens1, hist_gens2, now_hist)  # 答えの計算
        println(ans)
    end
    return 
end


function main()
    # 入力
    M, ϵ = input1()
    if ϵ == 0.00    # 誤り率が0.00の時は特別
        solve_pattern0(M)
        return 
    end
    solve(M, ϵ)
    return 
end


main()
