# ternary_search_tree
# 三分探索
# 閉区間[a, b]において，極値を一つ持つ関数のfの極値を探索するアルゴリズム

# 探索する区間は数学的考察によって狭くできるならした方が良い
# オーバーフローの危険性があるため
# 探索するのが整数の場合，[r, l]の範囲を適当に狭めて，最後は総当たりするのもあり


function f(x::Real)::Real
    return x
end

function solve()
    l, r = 0, 10^18
    while r-l>1e-3      # 整数の場合，r-l>2
        c1 = l + (r-l)/3        # 整数の場合 ÷
        c2 = r - (r-l)/3        # 整数の場合 
        if f(r) > f(l)
            c2 = r
        else
            c1 = l
        end
    end
    ans = minimum([f(l), f(r)])
    # ans = minimum([f(n) for n in l:r])    整数の場合
    println(ans)
end