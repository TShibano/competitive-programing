# 1.1 - B01.jl
# Date: 2023/02/06
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
parse_list_int(str=readline()) = parse.(Int, split(str))
parse_int(str=readline()) = parse(Int, str)

# composite types ====


# body ====

function solve()
    A, B = parse_list_int()
    println(A + B)
end


solve()
