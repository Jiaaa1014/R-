# 日期: 以Date類別表示

> d1 <- Sys.Date()
> d1
[1] "2017-11-23"
> class(d1)
[1] "Date"

# 從1970-01-01數過來的天數
> unclass(d1)
[1] 17493

> d2 <- as.Date("1969-01-01")
> unclass(d2)
[1] -365



# 時間: 以POSIXct, POSIXlt類別表示
> t1 <- Sys.time()
> t1
[1] "2017-11-23 21:47:30 CST"
> class(t1)
[1] "POSIXct" "POSIXt" 
# 從1970開始以來的秒數
> unclass(t1)
[1] 1511444850



> t2 <- as.POSIXlt(Sys.time())
> t2
[1] "2017-11-23 21:49:59 CST"

> class(t2)
[1] "POSIXlt" "POSIXt" 

# 比沒有強制`POSIXlt()`的`t1`還要更明確區分單位
> unclass(t2)
$sec
[1] 59.25164

$min
[1] 49

$hour
[1] 21

$mday
[1] 23

$mon
[1] 10

$year
[1] 117

$wday
[1] 4

$yday
[1] 326

$isdst
[1] 0

$zone
[1] "CST"

$gmtoff
[1] 28800

attr(,"tzone")
[1] ""    "CST" "CDT"

# 更清楚結構
> str(unclass(t2))
List of 11
 $ sec   : num 59.3
 $ min   : int 49
 $ hour  : int 21
 $ mday  : int 23
 $ mon   : int 10
 $ year  : int 117
 $ wday  : int 4
 $ yday  : int 326
 $ isdst : int 0
 $ zone  : chr "CST"
 $ gmtoff: int 28800
 - attr(*, "tzone")= chr [1:3] "" "CST" "CDT"

# 使用先前變數測試今天...
> weekdays(d1)
[1] "星期四"
> months(t1)
[1] "十一月"
> quarters(t2)
[1] "Q4"

# 改變格式，時間單位排列組合
> t4 <- strptime(t3, "%B %d, %Y %H:%M")
# 參考：http://blog.51cto.com/vindo/561850

> class(t4)
[1] "POSIXlt" "POSIXt" 


# 廢話
> Sys.time() > t1
[1] TRUE

# 差多久呢？
> Sys.time() - t1
Time difference of 20.49092 mins

# 用days來當單位
> difftime(Sys.time(), t1, units = 'days')
Time difference of 0.01463279 days

