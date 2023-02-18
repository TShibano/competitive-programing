# 2.1 - B06.jl
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
    N = parse_int()
    A = parse_list_int()
    cs = Vector{Int64}(undef, N+1)
    cs[1] = 0
    for i in 1:N
        cs[i+1] = cs[i] + ifelse(A[i]==1, 1, -1)
    end
    Q = parse_int()
    for q in 1:Q
        l, r = parse_list_int()
        val = cs[r+1] - cs[l]
        if val > 0
            println("win")
        elseif val == 0
            println("draw")
        else
            println("lose")
        end
    end
end

function editorial()
    N = parse_int()
    A = parse_list_int()
    atari_list = Vector{Int64}(undef, N+1)
    hazure_list = Vector{Int64}(undef, N+1)
    atari_list[1] = 0
    hazure_list[1] = 0
    for i in 1:N
        atari_list[i+1] = atari_list[i] + A[i]
        hazure_list[i+1] = hazure_list[i] + ifelse(A[i] == 0, 1, 0)
    end
    Q = parse_int()
    for q in 1:Q
        l, r = parse_list_int()
        num_atari = atari_list[r+1] - atari_list[l]
        num_hazure = hazure_list[r+1] - hazure_list[l]
        val = num_atari - num_hazure
        if val > 0
            println("win")
        elseif val == 0
            println("draw")
        else
            println("lose")
        end

    end
end


#solve()
editorial()
