# data(dataName, package = ""), file.info(path)

# check the BOM(byte-order mark): 
### readBin(lvr_land.path, what = "raw", n = 3)

# line by line
### readLines(file(lvr_land.path, encoding = "BIG5"), n = 5)

# in one line
### lvr_land.txt <- stringi::stri_encode(lvr_land.bin, "BIG-5", "UTF-8")
### solved it: read.table(textConnection(lvr_land.txt), header = TRUE, sep = ",")
### if MBCS = TRUE & UTF-8 = FALSE
### read.table(get_text_connection_by_l10n_info(lvr_land.txt), header = TRUE, sep = ",")

# beautify (data.frame form)
### read.table(file(lvr_land.path, encoding = "BIG5"), header = TRUE, sep = ",")



# 內建資料集
# 分析東西之前，要拉東西來用
# 像是這樣，檢視所有的資料集
> library(help=datasets)

# 原本`class(iris)`為data.frame的被我們覆蓋了...
> iris <- 1

# 如果我需要原始的`iris`呢？
# 從內建的資料集拿
> data(iris, package = "datasets")

##########

# 外建資料集
# 已經儲存好的變數
> lvr_land.path
[1] "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\01-RBasic-07-Loading-Dataset\\A_LVR_LAND_A.CSV"

# BOM用來標示這個檔案的編碼方式
# 求BOM的編碼是甚麼，得到的不是公定的編碼，所以先猜這個不帶BOM
> readBin(lvr_land.path, what = "raw", n = 3)
[1] b6 6d c2

# 對於是甚麼編碼沒有頭緒？
# 看輸出來的每一條line
# 第一行是header
> readLines(file(lvr_land.path, encoding = "BIG5"), n = 5)
[1] "鄉鎮市區,交易標的,土地區段位置或建物區門牌,土地移轉總面積平方公尺,都市土地使用分區,非都市土地使用分區,非都市土地使用編定,交易年月,交易筆棟數,移轉層次,總樓層數,建物型態,主要用途,主要建材,建築完成年月,建物移轉總面積平方公尺,建物現況格局-房,建物現況格局-廳,建物現況格局-衛,建物現況格局-隔間,有無管理組織,總價元,單價每平方公尺,車位類別,車位移轉總面積平方公尺,車位總價元,備註,編號"
[2] "文山區,房地(土地+建物),臺北市文山區木柵路二段109巷100弄61~90號,43.44,住,,,10407,土地2建物1車位0,十四層,十七層,住宅大樓(11層含以上有電梯),住家用,鋼筋混凝土造,0850925,73.83,2,2,1,有,有,9600000,130028,,0.0,0,,RPVOMLNJQHKFFAA97CA"                                                                                                                                                      
[3] "中正區,房地(土地+建物),臺北市中正區南海路1~30號,40.19,住,,,10406,土地1建物1車位0,一層,八層,店面(店鋪),住家用,鋼筋混凝土造,0830809,140.08,0,1,2,有,無,55680000,397487,,0.0,0,含增建或未登記建物。,RPOPMLNJQHKFFAA37CA"                                                                                                                                                                   
[4] "中正區,房地(土地+建物),臺北市中正區重慶南路三段121~150號,3.13,商,,,10407,土地2建物1車位0,九層,十二層,套房(1房1廳1衛),住家用,鋼筋混凝土造,0971117,32.81,1,1,1,有,有,6550000,199634,,0.0,0,含增建或未登記建物。,RPPPMLNJQHKFFAA47CA"                                                                                                                                                      
[5] "文山區,房地(土地+建物),臺北市文山區指南路三段32巷1~30號,8.79,住,,,10407,土地1建物1車位0,二層,十層,套房(1房1廳1衛),住家用,鋼筋混凝土造,0990806,39.55,1,1,1,有,有,6200000,156764,,0.0,0,含增建或未登記建物。,RPPNMLOJQHKFFAA37CA"                                                                                                                                                         
# n 超過原本19筆的資料量也只會印出19筆

# 得知資訊
> lvr_land.info <- file.info(lvr_land.path)
> lvr_land.info                                                                                                                             size isdir mode               mtime               ctime               atime exe
C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\01-RBasic-07-Loading-Dataset\\A_LVR_LAND_A.CSV 4594 FALSE  666 2017-11-22 18:15:49 2017-11-21 12:01:51 2017-11-21 12:01:51  no

# 過去常用的函式來試一遍
> attributes(lvr_land.info)
$names
[1] "size"  "isdir" "mode"  "mtime" "ctime" "atime" "exe"  
$class
[1] "data.frame"
$row.names
[1] "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\01-RBasic-07-Loading-Dataset\\A_LVR_LAND_A.CSV"
> class(lvr_land.info)
[1] "data.frame"
> names(lvr_land.info)
[1] "size"  "isdir" "mode"  "mtime" "ctime" "atime" "exe"  

# 來重寫，這次n設定為整個檔案的size，以位元的方式讀取
> lvr_land.bin <- readBin(lvr_land.path, what = "raw", n = lvr_land.info$size)
# 不要試著印出來...
# 不要試著印出來...
# 不要試著印出來...
# 會有4000多個資料
> class(lvr_land.bin)
[1] "raw"
> attributes(lvr_land.bin)
NULL


# 先引入要用的package
> library(stringi)


# 將型態raw原先的編碼轉換後，存到一個變數中
> lvr_land.txt <- stri_encode(lvr_land.bin, "BIG-5", "UTF-8")
# 阿...資料都濃縮在一行了
> class(lvr_land.txt)
[1] "character"
> attributes(lvr_land.txt)
NULL


> read.table(lvr_land.path, fileEncoding = "BIG-5")
# 得出來的表格，中文都靠右去了
# 預設`reader = FALSE`，所以header名稱占用到row1

> lvr_land <- read.table(file(lvr_land.path, encoding = "BIG5"), header = TRUE, sep = ",")
# 顯示的方式好看多
> class(lvr_land)
[1] "data.frame"
> attributes(lvr_land)
$names
 [1] "鄉鎮市區"                 "交易標的"                 "土地區段位置或建物區門牌"
 [4] "土地移轉總面積平方公尺"   "都市土地使用分區"         "非都市土地使用分區"      
 [7] "非都市土地使用編定"       "交易年月"                 "交易筆棟數"              
[10] "移轉層次"                 "總樓層數"                 "建物型態"                
[13] "主要用途"                 "主要建材"                 "建築完成年月"            
[16] "建物移轉總面積平方公尺"   "建物現況格局.房"          "建物現況格局.廳"         
[19] "建物現況格局.衛"          "建物現況格局.隔間"        "有無管理組織"            
[22] "總價元"                   "單價每平方公尺"           "車位類別"                
[25] "車位移轉總面積平方公尺"   "車位總價元"               "備註"                    
[28] "編號"                    
$class
[1] "data.frame"
$row.names
 [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19


# 查詢OS對於編碼的支援狀況
> l10n_info()
$MBCS
[1] TRUE

$`UTF-8`
[1] FALSE

$`Latin-1`
[1] FALSE

$codepage
[1] 950

> textConnection(lvr_land.txt)
A connection with                            
description "lvr_land.txt"  
class       "textConnection"
mode        "r"             
text        "text"          
opened      "opened"        
can read    "yes"           
can write   "no"            

# 使用濃縮成一行的`lvr_land.txt`試試看
> read.table(textConnection(lvr_land.txt), header = TRUE, sep = ",")


# 在MBCS為TRUE而UTF-8為FALSE的情況下

> read.table(get_text_connection_by_l10n_info(lvr_land.txt), header = TRUE, sep = ",")
# 顯示的結果和`lvr_land`相同










orglist.path <-"C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\01-RBasic-07-Loading-Dataset\\orglist-100.CSV"

answer.raw <- readBin(orglist.path, what = "raw", n = file.info(orglist.path)$size)
answer.txt <- stringi::stri_encode(answer.raw, from = "UTF-16", to = "UTF-8")
get_text_connection_by_l10n_info <- function(x) {
  info <- l10n_info()
  
  # 以下的if else是因為需要讓正確答案跨平台
  if (info$MBCS & !info$`UTF-8`) {
    textConnection(x)
  } else {
    textConnection(x, encoding = "UTF-8")
  }
}
answer <- read.table(get_text_connection_by_l10n_info(answer.txt), header = TRUE, sep = ",")



