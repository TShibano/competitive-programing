# 1.1 - A01.jl
# Date: 2023/02/06
# Version: 0.0.0
#== Solution
==#

# library ====
# using Statistics
# using Primes
# using DataStructures

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parse_list_int(str=readline()) = parse.(Int, split(str))
parse_int(str=readline()) = parse(Int, str)

# composite types ====


# body ====

function solve()
    N = parse_int()
    println(N^2)
end


solve()
