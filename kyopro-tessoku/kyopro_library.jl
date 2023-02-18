using Base: print_array
# kyopro_library.jl
# 競技プログラミングのためのライブラリ

# 標準入出力(stabdard input & output) ====
# 1個の入力(整数; Int64)
parse_int(str=readline()) = parse(Int64, str)
# 1行複数個の入力(整数; Int64)
# 受け取る変数を複数個にすれば各変数に値が入り，1個にすれば1次元配列(Vector)として受け取れる
parse_list_int(str=readline()) = parse.(Int64, split(str))
# N行複数個の入力(整数; Int64)
parse_list_int(N::Int64) = [parse_list_int() for _ in 1:N]

# 空白空け配列の出力
print_list(X::Vector{Int64}) = join(stdout, X, " ")

# 累積和(cumulative sum) ====
# 標準関数として`cumsum()`が入っている
"""いもす法"""
function imos()

end

# 二分探索(binary search) ====
"""二分探索
ソート済み配列`vec`中の値`x`のインデックスを二分探索で求める．
入っていない場合は-1を返す．
"""
function binary_search(vec::Vector{Real}, x::Real)::Int64
    l = 1
    r = length(vec)
    while l <= r
        mid = (l+r)÷2
        if A[mid] > x
            r = mid - 1
        elseif A[mid] == x
            return mid
        else
            l = mid + 1
        end
    end
    return -1
end

# グラフ ====
