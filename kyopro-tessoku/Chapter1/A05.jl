# 1.5 - A05.jl
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
    N, K = parse_list_int()
    ans = 0
    for i in 1:N
        for j in i:N
            for k in j:N
                if i + j + k == K
                    if i == j == k
                        ans += 1
                        break
                    elseif i == j || j == k || k == i
                        ans += 3
                        break
                    else
                        ans += 6
                        break
                    end
                end
            end
        end
    end
    println(ans)
end

function solve2()
    N, K = parse_list_int()
    ans::Int64 = 0
    for i in 1:N
        for j in 1:N
            if 1 <= K-i-j <= N
                ans += 1
            end
        end
    end
    println(ans)    
end


solve2()
