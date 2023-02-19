# 2.2 - A07.jl
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
    D = parse_int()
    N = parse_int()
    lst = zeros(Int64, D+1)
    for i in 1:N
        l, r = parse_list_int()
        lst[l] += 1
        lst[r+1] -= 1
    end
    ans_list = zeros(Int64, D+1)
    ans_list[1] = lst[1]
    for i in 1:D
        ans_list[i+1] = ans_list[i] + lst[i+1]
    end
    for i in 1:D
        println(ans_list[i])
    end
end


solve()
