# integer_problem.jl
# Date: 2022/06/05
# Version: 0.0.0
#== function list
## 約数
- 約数列挙
    - make_divisors()
## 素数
- 素数判定
    - is_prime()
- 素因数分解
    - prime_factorization()
- Nまでの素数の列挙(エラトステネスの篩)
    - Eratosthenes_sieve()
==#

# library ====
# using Statistics
# using Primes
# using DataStructures

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parseListInteger(str=readline()) = parse.(Int, split(str))
parseInteger(str=readline()) = parse(Int, str)

# 約数

"""約数列挙"""
function make_divisors(N::Integer)::Vector{Integer}
    divisors = Vector{Integer}()
    limit = trunc(Integer, N^0.5) + 1
    for i in 1:limit
        if N % i == 0
            push!(divisors, i)
            if i != N÷i
                push!(divisors, N÷i)
            end
        end
    end
    return sort(divisors)
end




# composite types ====
struct PrimeFactor
    prime::Integer      # 素数
    count::Integer      # 個数
end

"""素数の判定"""
function is_prime(N::Integer)::Bool
    if N == 1
        return false
    end
    limit = trunc(Integer, N^0.5) + 1
    for i in 2:limit
        if N%i == 0
            return false
        end
    end
    return true
end

"""素因数分解"""
function prime_factorization(N::Integer)::Vector{PrimeFactor}
    tmp = N
    ans = []
    limit = trunc(Integer, N^0.5) + 1
    for i in 2:limit
        count = 0
        while tmp%i == 0
            tmp = tmp÷i
            count += 1
        end
        if count != 0
            push!(ans, PrimeFactor(i, count))
        end
    end
    if tmp != 1
        push!(ans, PrimeFactor(tmp, 1))
    end
    if isempty(ans)
        push!(ans, PrimeFactor(N, 1))
    end
    return ans
end


"""エラトステネスの篩を用いて，N以下の素数を列挙する"""
function Eratosthenes_sieve(N::Integer)::Vector{Integer}
    if N <= 1       # 1以下は素数なし
        println("Please N >= 2")
        return []
    end
    prime_list = [2]
    limit = trunc(Integer, N^0.5)+1
    numeric_list = collect(3:2:N)
    while true
        prime = numeric_list[1]
        if prime >= limit
            return vcat(prime_list, numeric_list)
        end
        push!(prime_list, prime)
        numeric_list = [n for n in numeric_list if n%prime != 0]
    end
end




# body ====

function solve()
    
end


solve()