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

# 複合型において，filedがmutableなオブジェクトならstructでOK
# 蟻本を見て実装した．

# 2次元グリッドの場合は，1次元グリッドに変換してから実行する
# 2次元マップを1次元に圧縮した時に用いる座標変換関数
function uid(row::Int, column::Int, height::Int)::Int
    uid = row + height*(column - 1)
    return uid
end

struct UnionFind
    # parents: 親の要素の番号を表す．parents[i] = i の時iは根に当たる
    # rank: 木のランク．
    parents::Array{Int, 1}
    rank::Array{Int, 1}
    UnionFind(N) = new(collect(1:N), zeros(N))
end

# 木の根を求める
function find!(uf::UnionFind, x::Int)::Int
    if uf.parents[x] == x
        return x
    else
        return uf.parents[x] = find(uf, uf.parents[x])
    end
end

# xとyの属する集合を併合
function unite!(uf::UnionFind, x::Int, y::Int)::Bool
    x = find!(uf, x)
    y = find!(uf, y)
    if x == y
        return true
    end
    if uf.rank[x] < uf.rank[y]
        uf.parents[x] = y
    else
        uf.parents[y] = x
        if uf.rank[x] == uf.rank[y]
            uf.rank[x] += 1
        end
    end
    return true
end

# xとyが同じ集合に属するか否か
function same!(uf::UnionFind, x::Int, y::Int)::Bool
    return find!(uf, x) == find!(uf, y)
end

parseInt(str=readline()) = parse.(Int, split(str))

function main()
    N, Q = parseInt()
    uf = UnionFind(N)
    for i = 1:Q
        p, a, b = parseInt()
        a += 1
        b += 1
        if p == 0 # unite!
            unite!(uf, a, b)
        else # same!
            if same!(uf, a, b)
                println("Yes")
            else
                println("No")
            end
        end
    end
end

main()
