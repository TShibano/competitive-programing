# 2.5 - A10.jl
# Date: 2023/02/09
# Version: 0.0.0
#== Solution
左右から累積最大値を考える
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

function solve()
    N = parse_int()
    A = parse_list_int()
    D = parse_int()
    max_from_left = zeros(Int64, N)
    max_from_right = zeros(Int64, N)
    max_from_left[1] = A[1]
    max_from_right[N] = A[N]
    # 左からの最大値
    for i in 2:N
        max_from_left[i] = max(max_from_left[i-1], A[i])
    end
    # 右からの最大値
    for i in N-1:-1:1
        max_from_right[i] = max(max_from_right[i+1], A[i])
    end
    for _ in 1:D
        l, r = parse_list_int()
        ans = max(max_from_left[l-1], max_from_right[r+1])
        println(ans)
    end
end


solve()
