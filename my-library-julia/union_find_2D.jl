# UnionFind2D.jl
# UnionFindを二次元グリッドに拡張したもの
# 実装が大変なので，二次元グリッドを一次元グリッドに変換しましょう
# 

struct UnionFind2D
    # parents: 親の要素の番号を表す．parents[i] = i の時iは根に当たる
    # rank: 木のランク．
    parents::Array{Point, 2}
    rank::Array{Point, 2}
    UnionFind2D(H, W) = new(reshape([h+(w-1)*H for h=1:H, w=1:W], H, W), zeros(H, W))
end

# 木の根を求める
function find(uf2D::UnionFind2D, ax::Int, ay::Int)::Int
    if uf2D.parents[x] == x
        return x
    else
        return uf2D.parents[x] = find(uf2D, uf2D.parents[x])
    end
end

# xとyの属する集合を併合
function unite(uf2D::UnionFind2D, x::Int, y::Int)::Bool
    x = find(uf2D, x)
    y = find(uf2D, y)
    if x == y
        return true
    end
    if uf2D.rank[x] < uf2D.rank[y]
        uf2D.parents[x] = y
    else
        uf2D.parents[y] = x
        if uf2D.rank[x] == uf2D.rank[y]
            uf2D.rank[x] += 1
        end
    end
    return true
end

# xとyが同じ集合に属するか否か
function same(uf2D::UnionFind2D, x::Int, y::Int)::Bool
    return find(uf2D, x) == find(uf2D, y)
end

