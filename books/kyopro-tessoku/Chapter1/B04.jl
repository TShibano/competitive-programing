# 1.4 - B04.jl
# Date: 2023/02/07
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
    N = readline()
    ans = 0
    s = length(N)
    for i in 1:s
        ans += parse(Int8, N[i]) * (1 << (s-i))
    end
    println(ans)
end


solve()
