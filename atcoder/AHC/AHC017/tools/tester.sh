#!/bin/zsh
echo 'File names is ' $1
filename=$1".txt"
rm $filename
touch $filename
total_score=0
cnt=0
rm score.csv
touch score.csv
for var in `ls ./in/*.txt`
do
    n_var=${var:5}
    echo $n_var
    # cargo run --release --bin tester python3 ../src/sample.py < './in/'$n_var > './out/'$n_var 2>> $1
    # juliaを実行して，結果を./tools/out/xxxx.txtに出力
    julia ../src/main.jl './in/'$n_var './out/'$n_var
    # `vis`で./tools/out/xxxx.txtを読み込んで，スコアを算出する
    cargo run --release --bin vis './in/'$n_var './out/'$n_var 1>> $filename
    # 
    tmp_score=`sed -n '$p' $filename`
    tmp_score=${tmp_score:8}
    echo "$tmp_score" >> $1"_score.csv"
    total_score=$(( $total_score + $tmp_score ))
    cnt=$(( $cnt + 1))
    if test $(( $cnt % 50 )) -eq 0 ; then
        echo $cnt 
    fi
done
echo $total_score
