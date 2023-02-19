# UnionFind.jl
#= UnionFind木の特徴
併合と判定を高速に行うもの．(一回あたりの平均計算量はO(α(N))であり，αはアッカーマン関数の逆関数)
ただし分割は出来ない．
3つの関数から成り立つ．
- 初期化: n個のノードを用意する
- 併合: 片方のグループの木の根からもう片方のグループの木の根に辺をはる
- 判定: 木を上向きに辿り，その要素が含まれる木の根を調べ，同じ根にたどり着けば，同じグループである．

注意点
木構造のため，偏りが発生すると計算量が滅茶苦茶になる．
偏りを発生させないために，各木について木の高さ(rank)を記憶し，
併合の際にランクの小さいものから大きものへ辺を張る．

また辺の縮約を行うことで，より効率を上げることができる．
辺の縮約とは，各ノードについて一度根を辿ったら，辺を直接根に向かって張り直すということである．
また，検索を行なったノードだけでなく，その際に辿った全てのノードについて張り直すことができ，
2回目以降はすぐに根が分かるようになる．
一方で，縮約を行なって木の高さが変化しても，実装を簡単にするためrankは変更しない．
=#

# 複合型において，fieldがmutableなオブジェクトならstructでOK
# 蟻本を見て実装した．

# 2次元グリッドの場合は，1次元グリッドに変換してから実行する
# 2次元マップを1次元に圧縮した時に用いる座標変換関数
function uid(row::Int, column::Int, height::Int)::Int
    uid = row + height*(column - 1)
    return uid
end

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
        loop_list[x] = uf.loop_list[y]
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

function has_loop(uf::UnionFind, x::Int)::Int
    return uf.loop_list[find_root!(uf, x)]
end

parseInt(str=readline()) = parse.(Int, split(str))

function main()
    N, Q = parseInt()
    uf = UnionFind(N)
    for i = 1:Q
        a, b = parseInt()
        unite!(uf, a, b)
    end
    println(uf.loop_list)
    println(uf.parents)
end

main()
