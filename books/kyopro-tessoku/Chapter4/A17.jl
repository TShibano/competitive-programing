#  - A17.jl
# Date: 2023/04/04
# Version: 0.0.0
#== Solution
==#

# library ====
# using Statistics
# using Primes
# using DataStructures

# const ====
const MOD = 10^9 + 7
const INF = 10^14

# templete function ====
parseListInt(str=readline()) = parse.(Int, split(str))
parseInt(str=readline()) = parse(Int, str)

# composite types ====


# body ====

function solve()
  N = parseInt()
  A = parseListInt()
  B = parseListInt()
  dp = fill(INF, N)
  dp[1] = 0
  dp[2] = A[1]
  # dp[i] := 最短時間
  direct_list = fill(0, N)
  direct_list[1] = 0
  direct_list[2] = 1
  for i in 3:N
    # 1つ前からくる
    one = dp[i-1] + A[i-1]
    # 2つ前からくる
    two = dp[i-2] + B[i-2]
    if one <= two
      dp[i] = one
      direct_list[i] = i - 1
    else
      dp[i] = two
      direct_list[i] = i - 2
    end
  end
  ans = [N]
  d = N
  while d != 1
    d = direct_list[d]
    push!(ans, d)
  end
  l = length(ans)
  println(l)
  for i in l:-1:2
    print(ans[i], " ")
  end
  println(ans[1])
end


solve()
