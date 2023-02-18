# 3.4 - A14.jl
# Date: 2023/02/15
# Version: 0.0.0
#== Solution
==#

# library ====
# using Primes
# using DataStructures

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parse_list_int(str=readline()) = parse.(Int64, split(str))
parse_int(str=readline()) = parse(Int64, str)

# composite types ====


# body ====

function binary_search(x::Int64, vec::Vector{Int64})::Bool
    l = 1
    r = length(vec)
    while l <= r
        m = (l + r) ÷ 2
        if vec[m] == x
            return true
        elseif vec[m] > x
            r = m-1
        else
            l = m+1
        end
    end
    return false
end

function solve()
    N, K = parse_list_int()
    A = parse_list_int()
    B = parse_list_int()
    C = parse_list_int()
    D = parse_list_int()
    posAB = zeros(Int64, N*N)
    posCD = zeros(Int64, N*N)
    for i in 1:N
        for j in 1:N
            posAB[N*(i-1)+j] = A[i] + B[j]
        end
    end
    for i in 1:N
        for j in 1:N
            posCD[N*(i-1)+j] = C[i] + D[j]
        end
    end
    # 重複を排除する
    posAB = collect(Set(posAB))
    posCD = collect(Set(posCD))
    # 二分探索のためのソート
    sort!(posCD)
    # posABを取り出して，K-tmpがposCDの中にあれば良い
    for tmp in posAB
        if binary_search(K-tmp, posCD)
            println("Yes")
            return
        end
    end
    println("No")
end


solve()
