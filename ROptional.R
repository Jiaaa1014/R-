# LoopAndCondition


# i變大，下一個會越來越小
> for(i in 1:99) x[i + 1] <- x[i] - 0.2 * x[i]

# 正斜線不用跳脫\
> paste0("data/", 1, ".csv")
[1] "data/1.csv"

# 直接讀取三個檔案變成`list`
# data/1.csv"、"data/2.csv"、"data/3.csv
> for(i in c(1, 2, 3)) retval[[i]] <- read.table(paste0("data/", i, ".csv"))





# Function-Introduction


# 矩陣m * 向量x = 向量y，(m, y)已知
> m
   (Intercept) speed
1            1     4
2            1     4
3            1     7
4            1     7
5            1     8
6            1     9
7            1    10
8            1    10
### 省略
49           1    24
50           1    25
attr(,"assign")
[1] 0 1

> y
 [1]   2  10   4  22  16  10  18  26  34  17  28  14  20  24  28  26  34  34  46  26  36  60  80  20  26  54  32  40  32  40  50  42  56  76  84  36  46
[38]  68  32  48  52  56  64  66  54  70  92  93 120  85

# 設一個函式
> f <- function(x) sum((x - y) ^2)
> f(m %*% c(-17, 4))
[1] 11491

> f(mean(y))
[1] 32538.98

# 這樣子更快更方便
> f1 <- function(x) f(m %*% x)
> f1(c(-17, 4))
[1] 11491

> f1(c(1, 1))
[1] 58459


# 使用`optim()`找出向量使得`f1`輸出最小
> r <- optim(c(0, 0), f1)

> r
$par
[1] -17.571729   3.931832

$value
[1] 11353.52

$counts
function gradient 
      91       NA 

$convergence
[1] 0

$message
NULL

# 用另外的方式來確認，答案和`r$par`相同
> solve(t(m) %*% m, t(m) %*% y)
                  [,1]
(Intercept) -17.579095
speed         3.932409


