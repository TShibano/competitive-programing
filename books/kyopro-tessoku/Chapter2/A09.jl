# 2.4 - A09.jl
# Date: 2023/02/09
# Version: 0.0.0
#== Solution
#いもす法の2次元拡張
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
    H, W, N = parse_list_int()
    cum_field = zeros(Int64, H+1, W+1)
    for n in 1:N
        a, b, c, d = parse_list_int()
        cum_field[a, b] += 1
        cum_field[a, d+1] -= 1
        cum_field[c+1, b] -= 1
        cum_field[c+1, d+1] += 1
    end
    # 横方向の累積和
    for h in 1:H
        for w in 1:W
            cum_field[h, w+1] += cum_field[h, w]
        end
    end
    for w in 1:W
        for h in 1:H
            cum_field[h+1, w] += cum_field[h, w]
        end
    end
    for h in 1:H
        join(stdout, cum_field[h, 1:W], " ")
        println("")
    end
end


solve()
