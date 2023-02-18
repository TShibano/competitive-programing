# 2.3 - A08.jl
# Date: 2023/02/09
# Version: 0.0.0
#== Solution
2次元累積和
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
    H, W = parse_list_int()
    X = []
    for i in 1:H
        push!(X, parse_list_int())
    end
    sumX = zeros(Int64, H+1, W+1)
    for h in 1:H
        for w in 1:W
            sumX[h+1, w+1] = X[h][w] + sumX[h, w+1] + sumX[h+1, w] - sumX[h, w]
        end
    end
    Q = parse_int()
    for q in 1:Q
        a, b, c, d = parse_list_int()
        ans = sumX[c+1, d+1] - sumX[c+1, b] - sumX[a, d+1] + sumX[a, b]
        println(ans)
    end
end


solve()
