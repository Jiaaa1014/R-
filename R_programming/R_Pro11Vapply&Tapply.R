# 前一節中，取出30種資料的值，不重複，又臭又長的lists
> sapply(flags, unique)

# 原本預期每個小list都是長度1，但第一個就不是惹
> vapply(flags, unique, numeric(1))
Error in vapply(flags, unique, numeric(1)) : 值的長度必須是 1，
但是 FUN(X[[1]]) 的結果長度是 194

# 也是上一節，判斷30種資料的`class()`
> sapply(flags, class)
      name   landmass       zone       area population   language   religion 
  "factor"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
      bars    stripes    colours        red      green       blue       gold 
 "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
     white      black     orange    mainhue    circles    crosses   saltires 
 "integer"  "integer"  "integer"   "factor"  "integer"  "integer"  "integer" 
  quarters   sunstars   crescent   triangle       icon    animate       text 
 "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
   topleft   botright 
  "factor"   "factor" 

# 得到和`vapply()`一樣的結果
# 在抓取資料的方式上習慣`sapply()`
# 而`vapply()`再大量資料時，感受會比較快，更安全(?)
> vapply(flags, class, character(1))


# 分為哪幾個大陸板塊
> table(flags$landmass)

1  2  3  4  5  6 
31 17 35 52 39 20 


# 依照大陸編號來分析每個陸地有`animate`的比例
> tapply(flags$animate, flags$landmass, mean)
        1         2         3         4         5         6 
0.4193548 0.1764706 0.1142857 0.1346154 0.1538462 0.3000000 


# 依照國旗是否有使用紅色來判斷人口數量
> tapply(flags$population, flags$red, summary)
$`0`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    0.00    3.00   27.63    9.00  684.00 

$`1`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    0.0     0.0     4.0    22.1    15.0  1008.0 


# 依照大陸編號來判斷人口數量
> tapply(flags$population, flags$landmass, summary)
$`1`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    0.00    0.00   12.29    4.50  231.00 

$`2`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    1.00    6.00   15.71   15.00  119.00 

$`3`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    0.00    8.00   13.86   16.00   61.00 

$`4`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   1.000   5.000   8.788   9.750  56.000 

$`5`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    2.00   10.00   69.18   39.00 1008.00 

$`6`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00    0.00    0.00   11.30    1.25  157.00 


