# 3.3 - A13.jl
# Date: 2023/02/15
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
    N, K = parse_list_int()
    A = parse_list_int()
    ans = 0
    r = 1
    for i in 1:N-1
        while A[r] - A[i] <= K
            if r == N
                break
            end
            if A[r+1] - A[i] > K
                break
            end
            r += 1
        end
        ans += r-i
    end
    println(ans)
end


solve()
