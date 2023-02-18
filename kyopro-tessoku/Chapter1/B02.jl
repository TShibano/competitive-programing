# 1.2 - B02.jl
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
parse_list_int(str=readline()) = parse.(Int64, split(str))
parse_int(str=readline()) = parse(Int64, str)

# composite types ====


# body ====

function solve()
    A, B = parse_list_int()
    for i in A:B
        if 100 % i == 0
            println("Yes")
            return 
        end
    end
    println("No")
    return 
end


solve()
