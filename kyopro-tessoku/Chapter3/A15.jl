# 3.5 - A15.jl
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
function binary_search(x::Int64, vec::Vector{Int64}, s::Int64)::Int64
    l = 1
    r = s
    while l <= r
        m = (l+r)÷2
        if vec[m] == x
            return m
        elseif vec[m] < x
            l = m + 1
        else
            r = m - 1
        end
    end
end

function solve()
    N = parse_int()
    A = parse_list_int()
    sA = sort(collect(Set(A)))
    B = zeros(Int64, N)
    s = length(sA)
    for i in 1:N
        # 二分探索でA[i]のsAのインデックスを探索する
        B[i] = binary_search(A[i], sA, s)
    end
    join(stdout, B, " ")
    print("\n")
end


solve()
