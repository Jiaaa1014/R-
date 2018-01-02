# 載入`dplyr`，打開文件指引
> library(dplyr)
> vignette("two-table", package = "dplyr")
# 載入`nycflights13`
> library(nycflights13)

# 查看航空公司的縮寫對照
> View(airlines )

# 第1筆的航班資訊
> slice(flights,1)


#################################################
# 將公司全名補充接在`flights`後頭
answer01 <- local({
  slice(flights, 1:100) %>%
    select(year:day, hour, origin, dest, tailnum, carrier) %>%
    left_join(y = airlines, by = "carrier")
})
#################################################

# 將`weather`資料繼續接在後面，雖然`weather`的資訊的origin只有EWR
> answer02 <- left_join(answer01, weather)
Joining, by = c("year", "month", "day", "hour", "origin")

# 沒有`by`參數，兩個資料的依據是甚麼呢？
> intersect(colnames(answer01), colnames(weather))
[1] "year"   "month"  "day"    "hour"   "origin"


# 若兩批資料，命名地點的代稱不同...？
# 這是有名字的字串向量
> c("origin" = "faa")
origin 
 "faa" 
 
# 連續比對`flights`裡面兩個數值`origin`, `dest`
> answer03 <- left_join(answer02, airports, by = c("origin" = "faa"))
> answer04 <- left_join(answer03, airports, by = c("dest" = "faa"))

# 有`.x`或`.y`是因為在接資料的時候撞名，只好把留在原地的以此類推`.x`
> colnames(answer04)
 [1] "year"       "month"      "day"        "hour"       "origin"     "dest"       "tailnum"   
 [8] "carrier"    "name.x"     "temp"       "dewp"       "humid"      "wind_dir"   "wind_speed"
[15] "wind_gust"  "precip"     "pressure"   "visib"      "name.y"     "lat.x"      "lon.x"     
[22] "alt.x"      "tz.x"       "dst.x"      "name"       "lat.y"      "lon.y"      "alt.y"     
[29] "tz.y"       "dst.y" 

# `cut()例子
# > cut(c(1:18), c(0, 7, 9, 23))
#  [1] (0,7]  (0,7]  (0,7]  (0,7]  (0,7]  (0,7]  (0,7]  (7,9]  (7,9]  (9,23] (9,23] (9,23] (9,23] (9,23]
# [15] (9,23] (9,23] (9,23] (9,23]


#################################################
# 選用的到的表格做比對，加入`weather`資訊，但最後只要兩個欄位訊息，且`is.na()`是FALSE
answer02.1 <- local({
  select(flights, year:day, hour, origin, dest, tailnum, carrier, arr_delay) %>%
    left_join(weather) %>%
    select(wind_speed, arr_delay) %>%
    filter(!is.na(wind_speed), !is.na(arr_delay))
})

stopifnot(nrow(answer02.1) == switch(packageVersion("nycflights13"), "0.1" = 116774, "0.2.0" = 326116, stop("Invalid nycflights13 version")))
stopifnot(sum(is.na(answer02.1$wind_speed)) == 0)
stopifnot(sum(is.nan(answer02.1$wind_speed)) == 0)
stopifnot(sum(is.na(answer02.1$arr_delay)) == 0)
stopifnot(sum(is.nan(answer02.1$arr_delay)) == 0)

# quantile做成一組一組的PR值(0,25,50,75,100)
answer02.2 <- quantile(answer02.1$wind_speed, seq(0, 1, by = 0.25))
stopifnot(length(answer02.2) == 5)
stopifnot(answer02.2[1] == 0)
stopifnot(answer02.2[5] == max(answer02.2))

# 最後，我們利用`cut`以及`answer02.2`針對原始的wind_speed做分類。
# 介於 answer02.2[1]至answer02.2[2]的風速，會被歸類為等級1，
# 介於 answer02.2[2]至answer02.2[3]的風速，會被歸類為等級2，
# 介於 answer02.2[3]至answer02.2[4]的風速，會被歸類為等級3，
# 介於 answer02.2[4]至answer02.2[5]的風速，會被歸類為等級4。
# 每個等級的平均delay時間
answer02.3 <- local({
  mutate(answer02.1, wind_speed = cut(wind_speed, breaks = c(answer02.2[1]-1e-5, tail(answer02.2, -1)))) %>%
    group_by(wind_speed) %>%
    summarise(mean(arr_delay))
})
stopifnot(nrow(answer02.3) == 4)
stopifnot(colnames(answer02.3) == c("wind_speed", "mean(arr_delay)"))
if (packageVersion("nycflights13") != "0.2.0") stopifnot(answer02.3[[2]] > 4)
stopifnot(answer02.3[[2]] < 16)
#################################################


> df1
  x y
1 1 2
2 2 1
> df2
  x  a b
1 1 10 a
2 3 10 a


# 查看github圖解
> wiki_join()
# `left_join`, `right_join`, `full_join`, `anti_join`, `semi_join`六種join函數

# 保留`df1`
> left_join(df1, df2)
Joining, by = "x"
  x y  a    b
1 1 2 10    a
2 2 1 NA <NA>

# 也同樣保留`df1`，但順序不同
> right_join(df2, df1)
Joining, by = "x"
  x  a    b y
1 1 10    a 2
2 2 NA <NA> 1

# 只留下大家都有的
> inner_join(df1, df2)
Joining, by = "x"
  x y  a b
1 1 2 10 a

# 有的就來，聯集
> full_join(df1, df2)
Joining, by = "x"
  x  y  a    b
1 1  2 10    a
2 2  1 NA <NA>
3 3 NA 10    a

# 共同有的不要，也就是比對失敗剩下的
> anti_join(df1, df2)
Joining, by = "x"
  x y
1 2 1


> df3
  x a b
1 1 1 1
2 1 1 2
3 2 2 3
4 2 2 4
> df4
  x c d
1 1 1 1
2 1 1 2
3 3 2 3
4 3 2 4

# 缺一不可，不能簡化
> inner_join(df3, df4)
Joining, by = "x"
  x a b c d
1 1 1 1 1 1
2 1 1 1 1 2
3 1 1 2 1 1
4 1 1 2 1 2

# 不同於`inner_join()`，成功地但是都寫上主角`x`就好等價於`df3[1:2,]`
> semi_join(df3, df4)
Joining, by = "x"
  x a b
1 1 1 1
2 1 1 2


#################################################
#' 請用各種方式讀取`gdp_path`的資料、整理資料，並把最後的結果存到變數`gdp`。
#' 提示：`gdp_path`中的第一欄數據是年/季、第二欄數據是該季的GDP(百萬)
#' 結果應該要有兩欄的數據，第一欄是年，第二欄是我國每年的GDP
#' 具體細節請參考最後的`stopifnot`的檢查事項
#' 提示：拿掉數據中間的逗號，請用：`gsub(pattern = ",", replacement = "", x = <你的字串向量>)`
gdp <- local({
  # 請填寫你的程式碼
  read.table(gdp_path, skip = 4, header = FALSE, sep = ",") %>%
    slice(1:132) %>%
    select(season = V1, gdp = V2) %>%
    mutate(
      season = as.character(season),
      year = substring(season, 1, 4),
      gdp = gsub(pattern = ",", replacement = "", x = gdp), 
      gdp = as.numeric(gdp) * 1000000) %>%
    group_by(year) %>%
    summarise(gdp = sum(gdp))
})
stopifnot(is.data.frame(gdp))
stopifnot(colnames(gdp) == c("year", "gdp"))
stopifnot(class(gdp$year) == "character")
stopifnot(class(gdp$gdp) == "numeric")
stopifnot(nrow(gdp) == 33)
stopifnot(range(gdp$year) == c("1981", "2013"))
stopifnot(range(gdp$gdp) == c(1810829,14564242) * 1000000)

#' cl_info的資料包含各家銀行的房貸餘額（mortgage_bal）資訊與資料的時間（data_dt）。
#' 請用各種方法整理cl_info的資料，把最後的結果整理至`cl_info_year`
#' 結果應該要有兩欄的數據，第一欄是年，第二欄是每年房貸餘額的值(請以每年的一月份資料為準)
#' 具體細節請參考最後的`stopifnot`檢查事項
cl_info_year <- local({
  select(cl_info, data_dt, mortgage_bal) %>%
    mutate(month = substring(data_dt,1,7)) %>%
    group_by(month) %>%
    summarise(mortgage_total_bal = sum(mortgage_bal, na.rm = TRUE)) %>%
    mutate(year = substring(month, 1, 4)) %>%
    group_by(year) %>%
    arrange(month) %>%
    summarise(month = head(month, 1), mortgage_total_bal = head(mortgage_total_bal, 1)) %>%
    select(year, mortgage_total_bal)
})

stopifnot(is.data.frame(cl_info_year))
stopifnot(colnames(cl_info_year) == c("year", "mortgage_total_bal"))
stopifnot(class(cl_info_year$year) == "character")
stopifnot(class(cl_info_year$mortgage_total_bal) == "numeric")
stopifnot(nrow(cl_info_year) == 9)
stopifnot(range(cl_info_year$year) == c("2006", "2014"))
stopifnot(range(cl_info_year$mortgage_total_bal) == c(3.79632e+12, 5.726784e+12))

#' 最後請同學用這門課程所學的技術整合`gdp`與`cl_info`的資料，
#' 計算出房貸餘額與gdp的比率（mortgage_total_bal / gdp）。
#' 請將結果輸出到一個data.frame，第一攔是年份，第二欄是房貸餘額的GDP佔有比率。
#' 細節請參考`stopifnot`的檢查
answerHW <- local({
  # 請在這邊填寫你的程式碼
  inner_join(cl_info_year, gdp, by = "year") %>%
    mutate(index = mortgage_total_bal / gdp) %>%
    select(year, index)
})

stopifnot(is.data.frame(answerHW))
stopifnot(nrow(answerHW) == 8)
stopifnot(colnames(answerHW) == c("year", "index"))
stopifnot(class(answerHW$year) == "character")
stopifnot(class(answerHW$index) == "numeric")
stopifnot(min(answerHW$index) > 0.3)
stopifnot(max(answerHW$index) < 0.4)
#################################################

