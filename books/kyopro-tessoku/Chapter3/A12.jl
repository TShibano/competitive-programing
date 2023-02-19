# 3.2 - A12.jl
# Date: 2023/02/14
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
#
function calc_num(N::Int64, A::Vector{Int64}, t::Int64)::Int64
    ret = 0
    for n in 1:N
        ret += t ÷ A[n]
    end
    return ret
end

function solve()
    N, K = parse_list_int()
    A = parse_list_int()
    l = 0
    r = 10^9 + 1
    while r - l >= 2
        mid = (l + r) ÷ 2
        val = calc_num(N, A, mid)
        if val >= K
            r = mid
        else
            l = mid
        end
    end
    if calc_num(N, A, l) >= K
        println(l)
    else
        println(r)
    end
end

function is_upper(N, A, x, K)::Bool
    tmp = 0
    for i in 1:N
        tmp += x ÷ A[i]
    end
    if tmp >= K
        return true
    else
        return false
    end
end

function editorial()
    N, K = parse_list_int()
    A = parse_list_int()
    l = 1
    r = 10^9
    while l < r
        m = (l+r)÷2
        if is_upper(N, A, m, K)
            r = m
        else
            l = m+1
        end
    end
    println(l)
end

#solve()
editorial()
