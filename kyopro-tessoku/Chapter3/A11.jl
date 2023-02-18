# 3.1 - A11.jl
# Date: 2023/02/13
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
    N, X = parse_list_int()
    A = parse_list_int()
    l = 1
    r = N
    while r - l > 1
        mid = (r+l) ÷ 2
        if A[mid] == X
            r = mid
            l = mid
        elseif  A[mid] > X
            r = mid
        else
            l = mid
        end
    end
    if A[l] == X
        ans = l
    elseif A[r] == X
        ans = r
    else A[mid] == X
        ans = mid
    end
    println(ans)
end

function editorial()
    N, X = parse_list_int()
    A = parse_list_int()
    l = 1
    r = N
    ans = -1
    while l <= r
        mid = (l+r)÷2
        if A[mid] > X
            r = mid - 1
        elseif A[mid] == X
            ans = mid
            break
        else
            l = mid + 1
        end
    end
    println(ans)
end


#solve()
editorial()
