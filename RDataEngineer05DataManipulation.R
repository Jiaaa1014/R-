# filter(data, conditions)
# arrange(data, params), desc(params) => from max to min
# min(data, na.rm = TRUE), NA should not be compared.
# select(data, params)
# distinct(select()), exclude the repeated value
# mutate(data, colnames = ???), new column
# summarise()
# sample_n(), sample_frac()
# group_by(data, categoryis?)

# 前面的DataBase單元有介紹dbWriteTable()可以來自於不同的套件
> help.search("dbWriteTable")
# RSQLite, DBI，第3個就是來自dylr套件
# 這套件的函數很值觀好懂


# 安裝dylr套件、載入> library(dplyr)

> check_then_install("dplyr", "0.4.3")
> library(dplyr)

# 查查別人貢獻撰寫的文章
> vignette(package = "dplyr")
# 不是"introduction"，而是"dplyr"這篇
> vignette("dplyr", package = "dplyr")

# 需要`nycflights13`套件裡的`flights`資料集
> install.packages("nycflights13")
> library(nycflights13)

> str(flights)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':       336776 obs. of  16 variables:
 $ year     : int  2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 ...
 $ month    : int  1 1 1 1 1 1 1 1 1 1 ...
 $ day      : int  1 1 1 1 1 1 1 1 1 1 ...
 $ dep_time : int  517 533 542 544 554 554 555 557 557 558 ...
 $ dep_delay: num  2 4 2 -1 -6 -4 -5 -3 -3 -2 ...
 $ arr_time : int  830 850 923 1004 812 740 913 709 838 753 ...
 $ arr_delay: num  11 20 33 -18 -25 12 19 -14 -8 8 ...
 $ carrier  : chr  "UA" "UA" "AA" "B6" ...
 $ tailnum  : chr  "N14228" "N24211" "N619AA" "N804JB" ...
 $ flight   : int  1545 1714 1141 725 461 1696 507 5708 79 301 ...
 $ origin   : chr  "EWR" "LGA" "JFK" "JFK" ...
 $ dest     : chr  "IAH" "IAH" "MIA" "BQN" ...
 $ air_time : num  227 227 160 183 116 150 158 53 140 138 ...
 $ distance : num  1400 1416 1089 1576 762 ...
 $ hour     : num  5 5 5 5 5 5 5 5 5 5 ...
 $ minute   : num  17 33 42 44 54 54 55 57 57 58 ...

> class(flights)
[1] "tbl_df"     "tbl"        "data.frame"
> mode(flights)
[1] "list"


# 過濾呈現想要的資訊
# `month == flights$month`，但不用這麼麻煩寫全名
> filter(flights, month == 1, day == 1)
# 等於
> flights[flights$month == 1 & flights$day == 1, ]
# A tibble: 842 x 16
    year month   day dep_time dep_delay arr_time arr_delay carrier tailnum flight origin  dest air_time distance  hour
   <int> <int> <int>    <int>     <dbl>    <int>     <dbl>   <chr>   <chr>  <int>  <chr> <chr>    <dbl>    <dbl> <dbl>
 1  2013     1     1      517         2      830        11      UA  N14228   1545    EWR   IAH      227     1400     5
 2  2013     1     1      533         4      850        20      UA  N24211   1714    LGA   IAH      227     1416     5
 3  2013     1     1      542         2      923        33      AA  N619AA   1141    JFK   MIA      160     1089     5
 4  2013     1     1      544        -1     1004       -18      B6  N804JB    725    JFK   BQN      183     1576     5
 5  2013     1     1      554        -6      812       -25      DL  N668DN    461    LGA   ATL      116      762     5
 6  2013     1     1      554        -4      740        12      UA  N39463   1696    EWR   ORD      150      719     5
 7  2013     1     1      555        -5      913        19      B6  N516JB    507    EWR   FLL      158     1065     5
 8  2013     1     1      557        -3      709       -14      EV  N829AS   5708    LGA   IAD       53      229     5
 9  2013     1     1      557        -3      838        -8      B6  N593JB     79    JFK   MCO      140      944     5
10  2013     1     1      558        -2      753         8      AA  N3ALAA    301    LGA   ORD      138      733     5
# ... with 832 more rows, and 1 more variables: minute <dbl>


#################################################
# 上面流程是以`filter()`來對flights做資料過濾
# 這次練習室使用`local()`，裡面的變數不會影響到外部
# local函數只會輸出最後一個expression的結果，

library(nycflights13)
answer01 <- local({
  # `month_is_1`和`day_is_1`都是33萬筆資料比較出來的boolean向量   
  month_is_1 <- flights$month == 1
  day_is_1 <- flights$day == 1
  # 將兩個boolean向量合併，都是`TRUE`才會是`TRUE`  
  is_target <- month_is_1 & day_is_1
  flights[is_target,]
})
#################################################


#################################################
library(nycflights13)
answer02 <- local({
  # 請從flights篩選出dep_delay > 0的資料，
  target <- filter(flights, flights$dep_delay > 0)
  nrow(target)
})
#################################################


# 過濾出filghts$tailnum含"AA"字眼的資料
# `fixed = FALSE`，則`pattern`會以正規表達式寫法來處理
> filter(flights, grepl(pattern = "AA", x = tailnum, fixed = TRUE))

# 取出第10000到20000筆的資料
> slice(flights, 10000:20000)

# 比大小，參數誰先誰先比較
> arrange(flights, month, day, dep_time)
# 意即，得出來的`dep_time`值的確是升冪排列，但因為其他`month`, `day`太大了
# 以至於有些小的dep_time被排在後面

> min(flights$dep_time)
[1] NA
# 確保MissingValue不會擋到判斷
> min(flights$dep_time, na.rm = TRUE)
[1] 1

# 由大到小，使用`desc`
arrange(flights, desc(month), desc(day), desc(dep_time))

# 自助餐
> select(flights, year, month, day)
# A tibble: 336,776 x 3
    year month   day
   <int> <int> <int>
 1  2013     1     1
 2  2013     1     1
 3  2013     1     1
 4  2013     1     1
 5  2013     1     1
 6  2013     1     1
 7  2013     1     1
 8  2013     1     1
 9  2013     1     1
10  2013     1     1
# ... with 336,766 more rows

# 欄位
> names(flights)
 [1] "year"      "month"     "day"       "dep_time"  "dep_delay" "arr_time"  "arr_delay" "carrier"   "tailnum"   "flight"   
[11] "origin"    "dest"      "air_time"  "distance"  "hour"      "minute"   

# 只消`year`到`day`的欄位
> select(flights, year:day)

# 不要`year`到`day`的欄位
> select(flights, -(year:day))


#################################################
library(dplyr)
answer03 <- local({
  depTimeNA <- filter(flights, is.na(dep_time))
  result <-
    select(depTimeNA, year:day)
    # 並請用select從result1挑出year, month 和day。
})
#################################################


# 所選取的條件不會有重複的
> distinct(select(flights, year:day))
# A tibble: 365 x 3
    year month   day
   <int> <int> <int>
 1  2013     1     1
 2  2013     1     2
 3  2013     1     3
 4  2013     1     4
 5  2013     1     5
 6  2013     1     6
 7  2013     1     7
 8  2013     1     8
 9  2013     1     9
10  2013     1    10
# ... with 355 more rows

# 多一欄表格，由當前存在的factor來計算
> mutate(flights, gain = arr_delay - dep_delay)

# 平均誤點的時間
summarise(flights, mean(dep_delay, na.rm = TRUE))

# 隨機取10筆資料
> sample_n(flights, 10)

# 取1%的量
sample_frac(flights, 0.01)


#################################################
# 我們定義gain為arr_delay - dep_delay。
# 請算出1 月份平均的gain。
library(nycflights13)
answer04.1 <- local({
  filter(flights, month == 1) %>%
    mutate(gain = arr_delay - dep_delay) %>%
    summarise(mean(gain, na.rm = TRUE)) %>%
    `[[`(1)
})
stopifnot(class(answer04.1) == "numeric")
stopifnot(length(answer04.1) == 1)

# 請問是不是carrier為AA的飛機tailnum都有AA字眼呢？
answer04.2 <- local({
  
  filter(flights, carrier == "AA", !grepl("AA", tailnum)) %>%
    nrow == 0
  
})
stopifnot(class(answer04.2) == "logical")
stopifnot(length(answer04.2) == 1)

# 請問dep_time介於 2301至2400之間的平均dep_delay為多少呢?
answer04.3 <- local({
   
  filter(flights, 2400 >= dep_time, dep_time >= 2301) %>%
    summarise(mean(dep_delay), na.rm = TRUE) %>%
  `[[`(1)

  })
stopifnot(class(answer04.3) == "numeric")
stopifnot(length(answer04.3) == 1)

# 請問dep_time介於 1至 100之間的平均dep_delay為多少呢?
answer04.4 <- local({
  filter(flights, 100 >= dep_time, dep_time >= 1) %>%
    summarise(mean(dep_delay), na.rm = TRUE) %>%
    `[[`(1)
})
stopifnot(class(answer04.4) == "numeric")
stopifnot(length(answer04.4) == 1)

#################################################


# pipeline operator，`%>%`
# 把上一件事情完成後包裹到下一個函數

# 切割資料
df <- group_by(flights, month)


# 剛剛的
answer04.1 <- local({
  filter(flights, month == 1) %>%
    mutate(gain = arr_delay - dep_delay) %>%
    summarise(mean(gain, na.rm = TRUE)) %>%
    `[[`(1)
})
# group_by()已經幫你每個月分好個別求mean呢
# 可改寫成
group_by(flights, month) %>%
  mutate(gain = arr_delay - dep_delay) %>%
  summarise(mean(gain, na.rm = TRUE))
# A tibble: 12 x 2
   month `mean(gain, na.rm = TRUE)`
   <int>                      <dbl>
 1     1                  -3.855519
 2     2                  -5.147220
 3     3                  -7.356713
 4     4                  -2.673124
 5     5                  -9.370201
 6     6                  -4.244284
 7     7                  -4.810872
 8     8                  -6.529872
 9     9                 -10.648649
10    10                  -6.400238
11    11                  -4.958993
12    12                  -1.611806





arrange >> ORDER BY
select >> SELECT
filter >> WHERE
distinct >> DISTINCT
