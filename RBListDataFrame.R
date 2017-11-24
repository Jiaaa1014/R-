# 分析資料用的回歸是以`list`作為資料結構基底的
# list就是R物件的向量，有順序性

# 建立list，使用iris以及cars的資料，n = 2
x <- list(iris = iris, cars = cars, n = 2)

# 下面快速看看
# 簡而言之，mode於class，如科於屬，後者都更細分
> mode(x[1])
[1] "list"
> mode(x[2])
[1] "list"
> mode(x[3])
[1] "list"

> class(x[1])
[1] "list"
> class(x[2])
[1] "list"
> class(x[3])
[1] "list"

> mode(x[[1]])
[1] "list"
> mode(x[[2]])
[1] "list"
> mode(x[[3]])
[1] "numeric"

> class(x[[1]])
[1] "data.frame"
> class(x[[2]])
[1] "data.frame"
> class(x[[3]])
[1] "numeric"

# 取出內容
> x[['n']]
# 等於
> x$n
[1] 2

# matrix以及array有元素必須同性質的問題，在分析上比較麻煩
# data.frame是list的一種(class = data.frame, mode = list)
# data.frame可以容忍這些類型： 數值(numeric)、字串(character)、布林(logical)、類別(factor)、
#            數值矩陣(numeric matrix)、 list或data.frame。

# 當然，表格的長度要一樣嘛，就像分析30個人結果有些10個人的樣本能看嗎...
# 通常是row固定

# 建立data.frame
> a <- data.frame(class = "NTU", id = 1:10, scores = matrix(c(80:99), nrow = 10, ncol = 2))
> a
   class id scores.1 scores.2
1    NTU  1       80       90
2    NTU  2       81       91
3    NTU  3       82       92
4    NTU  4       83       93
5    NTU  5       84       94
6    NTU  6       85       95
7    NTU  7       86       96
8    NTU  8       87       97
9    NTU  9       88       98
10   NTU 10       89       99

> a[, 1]
 [1] NTU NTU NTU NTU NTU NTU NTU NTU NTU NTU
Levels: NTU

# `factor`以及`integer`給`mode()`判斷都是`numeric`
# a[, 1]之外的a[, n]以`attributes()`判斷都是NULL，沒有class的

> mode(a[,1])
[1] "numeric"
> mode(a[,2])
[1] "numeric"
> mode(a[,3])
[1] "numeric"
> mode(a[,4])
[1] "numeric"

> class(a[,1])
[1] "factor"
> class(a[,2])
[1] "integer"
> class(a[,3])
[1] "integer"
> class(a[,4])
[1] "integer"


# 第一列的名字是欄位給的，row.names是自己的
> attributes(a[1,])
$names
[1] "class"    "id"       "scores.1" "scores.2"
$row.names
[1] 1
$class
[1] "data.frame"

# 整個a
> attributes(a)
$names
[1] "class"    "id"       "scores.1" "scores.2"
$row.names
 [1]  1  2  3  4  5  6  7  8  9 10
$class
[1] "data.frame"

# `names(a)` 和 `colname(a)`的值都是
[1] "class"    "id"       "scores.1" "scores.2"


# 又來拿東西了

# 得到data.frame
> a[1:2, 1:2]
  class id
1   NTU  1
2   NTU  2
# 得到向量
> a[1:2,"id"]
[1] 1 2

# 設置`drop = FALSE`，將能簡化的簡化
> a[1:2,"id", drop = FALSE]
  id
1  1
2  2


