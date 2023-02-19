# 1.4 - A04.jl
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
    N = parse_int()
    lst = zeros(Int8, 10)
    for i in 1:10
        tmp = N % 2
        N ÷= 2
        lst[i] = tmp
    end
    ans = ""
    for i in 10:-1:1
        ans *= string(lst[i])
    end
    println(ans)
end

function editorial()
    N = parse_int()
    for i in 9:-1:0
        w = (1 << i)
        print((N ÷ w)%2)
    end
    print("\n")
end


#solve()
editorial()
