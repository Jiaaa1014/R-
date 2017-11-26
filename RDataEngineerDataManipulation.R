# 前面的DataBase單元有介紹dbWriteTable()可以來自於不同的套件
# RSQLite, DBI，這個第3個dylr的函數很值觀好懂，透過下面指令可以查詢
> help.search("dbWriteTable")

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


