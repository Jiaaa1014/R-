# `infert`為內建資料，不孕症與流產的關係

> View(infert)

# 儲存變數
> spon <- infert$spontaneous
> class(spon)
[1] "numeric"


# 點點圖，流產次數為y軸，看不出趨勢
> plot(spon)


# 轉換數據型態，則`spon`列印出來會多個`Levels: 0 1 2`
> spon <- factor(spon)
# 直條圖，流產次數在x軸
> plot(spon)


# 簡易表格
> table(spon)
spon
  0   1   2 
141  71  36 
> class(table(spon))
[1] "table"
# 圓餅圖，要先過`table`算過傳給`pie()`
> pie(table(spon))


> age <- infert$age
> plot(age)
# 和起初的`plot(spon)`一樣，看不出來趨勢

# 折線圖，有三個不明顯的波峰
> plot(age, type = "l")


# 直方圖，最簡陋的那種
> x <- hist(age)
> x
$breaks
 [1] 20 22 24 26 28 30 32 34 36 38 40 42 44

$counts
 [1]  6  9 30 45 24 36 18 33 20 15  9  3

$density
 [1] 0.012096774 0.018145161 0.060483871 0.090725806 0.048387097 0.072580645 0.036290323 0.066532258 0.040322581
[10] 0.030241935 0.018145161 0.006048387

$mids
 [1] 21 23 25 27 29 31 33 35 37 39 41 43

$xname
[1] "age"

$equidist
[1] TRUE

attr(,"class")
[1] "histogram"

# 在26以上至28歲有45人
> sum(age > 26 & age <= 28)
[1] 45


# 密度圖
> plot(density(age))
# bandwidth更窄，好醜，`bw`越大越平滑
> plot(density(age, bw = 0.1))
# `bw = "SJ"`為兩個峰，其他也有`"ucv", "bcv"`
# `bw = "ucv"`比0.1寬一點
# `bw = "bcv"`比"SJ"更平滑
> plot(density(age, bw = "SJ"))


# 1700-1988年的太陽黑子數量
> sunspot.year
Time Series:
Start = 1700 
End = 1988 
Frequency = 1 
  [1]   5.0  11.0  16.0  23.0  36.0  58.0  29.0  20.0  10.0   8.0   3.0   0.0   0.0   2.0
 [15]  11.0  27.0  47.0  63.0  60.0  39.0  28.0  26.0  22.0  11.0  21.0  40.0  78.0 122.0
    ##省略
[281] 154.7 140.5 115.9  66.6  45.9  17.9  13.4  29.2 100.2

> class(sunspot.year)
[1] "ts"
> mode(sunspot.year)
[1] "numeric"

# `ts`型態數據會直接依序把數據串起來(像密度圖)
> plot(sunspot.year)
# 但只要最後的100年
> x <- tail(sunspot.year,100)
> class(x)

# 只有點點，等同於`plot(x, type ="p")`
> plot(x)
# 串起來有線有點點
> lines(x)
# 設定樣式
# col有八種顏色
# lwd為線的寬度
> lines(x, lty = 3, lwd = 3, col = 2)


# 輸出圖片
> dst <- tempfile(fileext = ".png")
# 打開繪圖引擎
> png(dst)
# 則輸入`plot(x)`也不會有動作

# 關閉png的繪圖引擎
> dev.off()
windows 
      2 


# 若是用RStudio，可觀看剛剛儲存的圖片
> library(rstudioapi)
> viewer(dst)


# ????????????????????????????????????
> try(dev.off(), silent = TRUE)
null device 
          1 

# `hsb`紀載學生的基本資訊以及成績(200obs)
> str(hsb)
'data.frame':   200 obs. of  11 variables:
 $ id     : int  70 121 86 141 172 113 50 11 84 48 ...
 $ sex    : Factor w/ 2 levels "female","male": 2 1 2 2 2 2 2 2 2 2 ...
 $ race   : Factor w/ 4 levels "African American",..: 4 4 4 4 4 4 1 3 4 1 ...
 $ ses    : int  1 2 3 3 2 2 2 2 2 2 ...
 $ schtyp : Factor w/ 2 levels "private","public": 2 2 2 2 2 2 2 2 2 2 ...
 $ prog   : Factor w/ 3 levels "academic","general",..: 2 3 2 3 1 1 2 1 2 1 ...
 $ read   : int  57 68 44 63 47 44 50 34 63 57 ...
 $ write  : int  52 59 33 44 52 52 59 46 57 -99 ...
 $ math   : int  41 53 54 47 57 51 42 45 54 52 ...
 $ science: int  47 63 58 53 53 63 53 39 58 50 ...
 $ socst  : int  57 61 31 56 61 61 61 36 51 51 ...

# 密度圖：寫作成績
> plot(density(hsb$write, bw = "SJ"))
# 特別的是遺失資料會以-99來紀載，因此跑出一個很左邊的波峰可以讓我們直觀看到異常

# 圓餅圖，記得要先丟給`table()`
> pie(table(hsb$sex))


# %>% 屬於`magrittr`套件
# 可以引入`dplyr`來寫可以???????????????
> table(hsb$sex) %>% pie()



# 直方圖與圓餅圖操作

#################################################
# 建立math物件
hsb_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\03-RVisualization-01-One-Variable-Visualization\\hsb.csv"
hsb <- read.table(file(hsb_path, encoding = "UTF-8"), header = TRUE, sep = ",")
math <- hsb$math
hist(math)

# 改變title
hist(math, main = "Histogram of math!")

# 改變x軸說明
hist(math, xlab = "Value of math")

# 改變y軸說明
hist(math, ylab = "frequency")

# 改變顏色
hist(math, col = "blue")

# 圖標
legend("topright", "test")

# 改變切割點
hist(math, breaks = 2)
hist(math, breaks = 10)
hist(math, breaks = 20)
#################################################

#################################################
# 先建立sex物件
sex <- table(hsb$sex)

# 預設圖
pie(sex)

# 加上標題
pie(sex, main = "Sex")

# 改顏色
col <- rainbow(length(sex)) # 利用rainbow函數產生若干種不同的色系
col # 這是RGB的值
pie(sex, main = "Sex", col = col)

# 加上比率
pct <- sex / sum(sex) * 100 # 計算百分比
label <- paste0(names(sex), "---", pct, "%") # 產生說明文字
label # 同學可以比較label, names(sex), pct 和 "%" 的結果
pie(sex, labels = label)

if (FALSE) {
  # 3D pie chart
  library(plotrix) # 同學請自行安裝這個套件
  pie3D(sex, labels = label)
}
#################################################
