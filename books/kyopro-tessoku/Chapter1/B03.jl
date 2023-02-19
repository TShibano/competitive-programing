# 1.3 - B03.jl
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
    N = parse_int()
    A = parse_list_int()
    for i in 1:N-2
        for j in i+1:N-1
            for k in j+1:N
                if A[i] + A[j] + A[k] == 1000
                    println("Yes")
                    return
                end
            end
        end
    end
    println("No")
    return
end


solve()
