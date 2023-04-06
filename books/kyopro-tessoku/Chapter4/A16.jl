#  - A16.jl
# Date: 2023/02/28
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

function solve()
    #test
    N = parse_int()
    A = parse_list_int()
    B = parse_list_int()
    # 貰うdpを考える
    # dp[i] := 部屋iにたどり着く間にかかる最短時間
    dp = fill(INF, N)
    dp[1] = 0
    dp[2] = A[2-1]
    for i in 3:N
        dp[i] = min(dp[i-1] + A[i-1], dp[i-2] + B[i-2])
    end
    println(dp[N])
end


solve()
