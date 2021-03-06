# c(...), min(), max(), sum(), length(), mean(), sqrt() 
# variance: sum((x-mean())^2) / (length(x) - 1), var(x) 
# standard deviation: sd(x)
# ordering: sort(x, decresing = FALSE, ...)
# seq(): from, to, by, length.out, along.with
# rep(): time, each
# check if lose value: is.na()
# paste()--> default space; paste0()--> no space


# 建立向量
x <- c(10.4, 5.6, 3.1, 6.4)

# 加減
> c(1, 2, 3) + c(2, 4, 6)
[1] 3 6 9

> 2 + c(1, 2, 3)
[1] 3 4 5

> c(min(x), max(x))
[1]  3.1 10.4
> range(x)
[1]  3.1 10.4

# 平均
> sum(x) / length(x)
[1] 6.375

# 變異數
> sum((x - mean(x))^2) / (length(x)-1)
# 或
> var(x)
[1] 9.175833
# 標準差
> sd(x)
[1] 3.029164

# 由小到大
# sort(x, decreasing = FALSE, ...)
> sort(x)
[1]  3.1  5.6  6.4 10.4

# 開根號當然不能是負數
> sqrt(-17)
[1] NaN
# 咦？
> sqrt(-17 + 0i)
[1] 0+4.123106i

# 先跑序列
# `:`優先於`*`
> 2 * 1:10
 [1]  2  4  6  8 10 12 14 16 18 20



# seq()
# `from`, `to`, `by`, `length.out`, `along.with`

> seq(to = 1,from = 10)
 [1] 10  9  8  7  6  5  4  3  2  1
> seq(1, 10, by = 0.5)
 [1]  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0  5.5  6.0  6.5  7.0  7.5  8.0  8.5  9.0  9.5 10.0
> seq(1, by = 2, length.out = 10)
 [1]  1  3  5  7  9 11 13 15 17 19

# `times`, `each`差別
> rep(x, times = 2)
[1] 10.4  5.6  3.1  6.4 10.4  5.6  3.1  6.4
> rep(x, each = 2)
[1] 10.4 10.4  5.6  5.6  3.1  3.1  6.4  6.4

# 向量條件，回傳向量的`TRUE`, `FALSE`
> x > 5
[1]  TRUE  TRUE FALSE  TRUE

# 有遺失嗎？
> is.na(x)
[1] FALSE FALSE FALSE FALSE

> is.na(c(NA, NaN, 1))
[1]  TRUE  TRUE FALSE



# `paste()`
> paste(c("X","Y"), 1:10)
 [1] "X 1"  "Y 2"  "X 3"  "Y 4"  "X 5"  "Y 6"  "X 7"  "Y 8"  "X 9"  "Y 10"
# 沒有空格
> paste0(c("X","Y"), 1:10)
 [1] "X1"  "Y2"  "X3"  "Y4"  "X5"  "Y6"  "X7"  "Y8"  "X9"  "Y10"

# 挑東西`[]`
> x[c(1,3)]
[1] 10.4  3.1
# 用條件挑東西
# 也可以用同樣長度，不同向量互相利用挑東西
> x[x > 5]
[1] 10.4  5.6  6.4
# 不要，`-`
> x[-2]
[1] 10.4  3.1  6.4

# 給個名字
> names(x) <- c("a","b","c","d")
> x
   a    b    c    d 
10.4  5.6  3.1  6.4 
> x[c("b","d")]
  b   d 
5.6 6.4 



