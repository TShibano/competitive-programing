# 第2章 累積和
## 2.0 累積和とは
- 配列の先頭から累計値を記録した配列
- 配列の特定の範囲の合計値をすぐに求めることができる

## 2.1 一次元の累積和(1)
- A06: How Many Guests?
    - 累積和を計算して，(R日の来場者) - (L-1日の来場者)
    - 累積和の計算はそれまでの合計値とその日の来場者を足し合わせる
    - 累積和の計算がO(N)，クエリの処理にO(Q)で，全体でO(N+Q)
- B06: Lottery
    - 当たりの個数と外れの個数それぞれの累積和を計算する
    - 外れの場合を-1として，1と-1の累積和を計算するというのでもいけた

## 2.2 一次元の累積和(2)
- いもす法
    - 増減(差分)を記録し，その増減の累積和を求める方法
- A07: Event Attendance
    - 参加者の前日比を記録し，累積和を計算することで，各日の出席者数が求まる
    - 前日比の計算にO(N)，累積和の計算にO(D)かかるので，計算量はO(N+D)

## 2.3 二次元の累積和(1)
- A08: Two Dimensional Sum
    - 二次元の累積和を取る
    - 累積和は横方向にとった後に，縦方向にとると良い
    - (縦横同時に見ることもできるので，そっちの方がループは少なくて済む)
    - 引く位置を気をつけて，該当する和を求める

## 2.4 二次元の累積和(2)
- A09: Winter in ALGO Kingdom
    - いもす法を二次元に拡張した方法
    - 計算量: O(HW + N) (前計算でO(N)，累積和の計算にO(HW))

## 2.5 チャレンジ問題
- A10: Resort Hotel
    - for文を回して愚直に最大値を求める方法は，計算量がO(ND)となる．
        - 最大値を計算するのにO(N)，それをD回繰り返すため
    - L~Rの部屋が使えない時，max(max(A[1] ~ A[L-1]), ,max(A[R+1] ~ A[N]) として求まる
    - よって，ML = max(A[1] ~ A[L-1]), MR = max(A[R+1] ~ A[N])を効率よく求められれば良い
    - MLは，先頭から最大値と今の値を比較して最大値を更新していけば良い(累積最大値を求める)
    - MRも同様に，最後から累積最大値を求める

## コラム3 アルゴリズムで使う数学
- べき乗
- 指数関数
- 対数関数
- 集合
- 和の公式
    - 1 + 2 + ... + N = N(N-1)/2
    - a^0 + a^1 + a^2 + ... = 1/(1-a)    (0 < a <1)
    - 1/1 + 1/2 + 1/3 + ... + 1/N ≒ ln(N)    ln: 自然対数
- 階乗
- 場合の数に関する公式
    - n! = n(n-1)(n-2)...3*2*1: n個のモノを並び替える
    - nCr = n!/(r! (n-r)!): n個のモノの中からr個選ぶ
    - nPr = n!/(n-r)!: n個のモノの中からr個選び，並び順まで決める