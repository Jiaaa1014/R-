#################################################
################ Missing Values #################
#################################################


# NA (not available) 無法做運算，即便在向量，它不管做甚麼始終是NA

# 隨機抽1000個標準常態分佈的向量
rnorm(1000)
# 補充
> dnorm(1.96)
[1] 0.05844094

# pnorm(),qnorm為一組互相求值
> pnorm(1.96)
[1] 0.9750021
> qnorm(0.9750021)
[1] 1.96

# 隨機抽樣100個值
>sample(c(y, z),100)


# NAN (Not A Number)
# 0 / 0, Inf - Inf

# 參考：https://github.com/programmermagazine/201303/blob/master/source/article3.md




#################################################
############## Subsetting Vectors ###############
#################################################


# x是rnorm以及NA所組成長度為40的向量，分別為20個

# 要x向量的前10個
> x[1:10]

# x[is.na(x)]
# 分解： is.na(x)，全部轉換為長度40的TRUE,FALSE組成的向量
# 分解： x[is.na(x)]，把TRUE全部過濾出來。列出長度為20，內容全是NA
# 分解： x[!is.na(x)]，把FALSE全部過濾出來。列出長度為20，內容為原本值的向量

> y <- x[!is.na(x)]

# 過濾出符合>0的值
> y[y>0]
 [1] 0.43791449 0.76662310 0.44165754 0.28529656 0.13197809 0.06282892 0.23787329 1.42155346
 [9] 2.15719142 0.57073190

# 但`x`做同樣的事卻被`NA`干擾，`NA > 0`還是`NA`
> x[x>0]
 [1] 0.43791449         NA         NA 0.76662310         NA         NA         NA         NA
 [9] 0.44165754         NA 0.28529656         NA 0.13197809         NA         NA         NA
[17]         NA         NA         NA         NA         NA 0.06282892 0.23787329         NA
[25] 1.42155346         NA         NA 2.15719142 0.57073190         NA

# 要讓上述變成上上述的解決方法
> x[!is.na(x) & x> 0]


# 抓出x第3, 5, 7的元素
> x[c(3, 5, 7)]

# 即便可以拿，但只能出現這樣
> x[0]
numeric(0)

> x[3000]
[1] NA

# 不要第2個，也不要第10個
> x[c(-2, -10)]
等於
> x[-c(2, 10)]

# 兩種有名字的向量建立方式
> vect <- c(foo = 11, bar = 2, norf = NA)
> vect2 <- c(11, 2, NA)
> names(vect2) <- c("foo", "bar", "norf")
> identical(vect, vect2)
[1] TRUE

# 想拿`bar`?
> vect["bar"]
> vect[2]




#################################################
########### Matrices and Data Frames ############
#################################################


# 用`1:20`創建向量沒有`dim()`喔
> dim(my_vector)
NULL

# 強制設row, col
> dim(my_vector) <- c(4,5)
> dim(my_vector)
[1] 4 5

# 是matrix的話

> class(my_vector)
[1] "matrix"

> attributes(my_vector)
$dim
[1] 4 5

# 物件可以是向量 (vector), 矩陣 (matrix), 陣列 (array), 列表 (Lists), 或 資料框架 (data frames) 等
# 以class()來測試
# 參考：http://web.ntpu.edu.tw/~cflin/Teach/R/R06EN03Object.pdf

# `my_matrix`是`my_vector`
> patients <- c("Bill","Gina","Kelly", "Sean")
> cbind(patients, my_matrix)
     patients                       
[1,] "Bill"   "1" "5" "9"  "13" "17"
[2,] "Gina"   "2" "6" "10" "14" "18"
[3,] "Kelly"  "3" "7" "11" "15" "19"
[4,] "Sean"   "4" "8" "12" "16" "20"

# 以`data.frame`格式好看多了
> my_data <- data.frame(patients, my_matrix)
> my_data
  patients X1 X2 X3 X4 X5
1     Bill  1  5  9 13 17
2     Gina  2  6 10 14 18
3    Kelly  3  7 11 15 19
4     Sean  4  8 12 16 20

# 測試
> class(my_data)
[1] "data.frame"

> cnames <- c("patient", "age", "weight", "bp", "rating", "test")

# col命名
> colnames(my_data) <- cnames

> my_data
  patient age weight bp rating test
1    Bill   1      5  9     13   17
2    Gina   2      6 10     14   18
3   Kelly   3      7 11     15   19
4    Sean   4      8 12     16   20




#################################################
##################### Logic #####################
#################################################


> TRUE & c(TRUE, FALSE, FALSE)
# 等於
> c(TRUE, TRUE, TRUE) & c(TRUE, FALSE, FALSE)
# 都是
[1] TRUE FALSE FALSE

# `&&`只會比第一個
> TRUE && c(TRUE, FALSE, FALSE)
[1] TRUE
> TRUE && c(FALSE, FALSE, FALSE)
[1] FALSE

# 這裡的邏輯和JavaScript不一樣
> isTRUE(6 > 4)
[1] TRUE
> isTRUE(0)
[1] FALSE
> isTRUE(3)
[1] FALSE

# `xor()`一正一反為`TRUE`
> xor(5==6, !FALSE)
[1] TRUE


# 1-10隨機排，不重複
> ints <- sample(10)
> ints
 [1] 10  3  8  9  4  6  2  1  7  5

# 找出`> 7`的indices(index)
> which(ints > 7)
[1] 1 3 4

# 只要有1個符合就是TRUE
> any(ints <0)
[1] FALSE

