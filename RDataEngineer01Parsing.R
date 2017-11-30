# 已有資料放在`hospital_path`
> hospital_path
[1] "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-01-Parsing\\DataGov25511.csv"


# 查詢BOM，`n = 3`
> readBin(hospital_path, what = "raw",n = 3L)
[1] 59 45 41

# 每種編碼方式的BOM不同
# UTF-16LE(FF FE)
# UTF-16BE(FE FF)
# UTF-8(EF BB BF)
# 59 45 41當然無法判別

# 不是`UTF-8`，失敗
> readLines(file(hospital_path, encoding = "UTF-8"), n = 6)
[1] "YEARYY,HOSPID,HOSPNAME,SPECIALNAME,CODE2,CODE3,CODE5,CODE8,CODE9,CODE10,CODE11,,"
[2] "100Q1,0501010019,"                

# 改成`BIG5`，成功
> readLines(file(hospital_path, encoding = "BIG5"), n = 6)
[1] "YEARYY,HOSPID,HOSPNAME,SPECIALNAME,CODE2,CODE3,CODE5,CODE8,CODE9,CODE10,CODE11,,"                                               
[2] "100Q1,0501010019,三軍總醫院松山分院附設民眾診療服務處                        ,區域醫院            ,45.00,3.84,0.9777,1,9,n,,,"  
[3] "100Q1,3501013040,安禾聯合診所                                                ,診所                ,179.00,4.04,0.9385,2,22,n,,,"
[4] "100Q1,3501011313,安德聯合診所                                                ,診所                ,230.00,3.94,0.9478,3,29,n,,,"
[5] "100Q1,1101010012,長庚醫療財團法人台北長庚紀念醫院                            ,醫學中心            ,212.00,3.97,0.9858,2,25,n,,,"
[6] "100Q1,3501013326,祐腎內科診所                                                ,診所                ,46.00,3.98,0.9782,1,5,n,y,," 

# 弄得好看一點麻～
> hospital <- read.table(file(hospital_path, encoding = "BIG5"), header = TRUE, sep = "," )


# R: `substring("abc", 1, 2)` //"ab"
> hospital$YEARYY
# 100Q1 100Q1 100Q1 100Q1 100Q1 100Q1 100Q1...
# 16000多的鬼東西

# 取出前6筆，再對每筆切割第1-3的字串
# R的參數比較直覺
# JS:substring(startIndex, endIndex)，不包含endIndex
> substring(head(hospital$YEARYY), 1, 3)
[1] "100" "100" "100" "100" "100" "100"

> yearyy <- as.character(hospital$YEARYY)
> yearyy
"100Q1" "100Q1" "100Q1" "100Q1" "100Q1" "100Q1" "100Q1"...
> class(yearyy)
[1] "character"
# 如果沒有as.character，回傳不會有""

# 以"Q"當成分水嶺切割，切成16000多筆資料
> tmp <- strsplit(yearyy, "Q")
> class(tmp)
[1] "list"


# list
> tmp[1]
[[1]]
[1] "100" "1"  

# character
> tmp[[1]]
[1] "100" "1"  

# character
> tmp[[1]][1]
[1] "100"


# 第1個參數: tmp --> c(tmp[[1]], tmp[[2]], ..., tmp[[16806]])
# 第2個參數: "[" --> 做出`[]`的動作，`FUN`
# 第3個參數:  1  --> 給第2個參數使用
> lapply(tmp, "[", 2)

> tmp2 <- lapply(tmp, "[", 1)
# 上面要跑很久又占空間，這次可以背靠背跑出來～
> unlist(tmp2)

> class(tmp2)
[1] "list"
> class(unlist(tmp2))
[1] "character"

# 同unlist(tmp2)效果
> sapply(tmp, "[", 1)











pirate_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-01-Parsing\\pirate-info-2015-09.txt"
pirate_info <- readLines(file(pirate_path, encoding = "BIG5"))



.dot <- strsplit(pirate_info[2], "")[[1]][3]

allChildren <-strsplit(pirate_info, .dot)


# 找老大是"經緯度"字串
longAndLat <- sapply(allChildren, "[", 1)

# 是否為經緯度字串
pirate_is_coordinate <- longAndLat == longAndLat[8]


# 經緯度數值都是在每組的排行老二
# 再以`pirate_is_coordinate`過濾
pirate_coordinate_raw <- sapply(allChildren, "[", 2)[pirate_is_coordinate]

# 切割數值
# 緯度
latitude <- as.integer(substring(pirate_coordinate_raw, 3, 4))
# 經度
longitude <- as.integer(substring(pirate_coordinate_raw, 12, 14))


result_df <- data.frame(latitude, longitude)
