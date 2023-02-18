# 2.1 - A06.jl
# Date: 2023/02/08
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
    N, Q = parse_list_int()
    A = parse_list_int()
    cA = zeros(Int64, N+1)
    for i in 2:N+1
        cA[i] = cA[i-1] + A[i-1]
    end
    for q in 1:Q
        l, r = parse_list_int()
        println(cA[r+1] - cA[l])
    end
end


solve()
