# 已有資料放在`hospital_path`
> hospital_path
[1] "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-01-Parsing\\DataGov25511.csv"


# n = 3也可
readBin(hospital_path, what = "raw", n = 3L)
> readBin(hospital_path, what = "raw",n = 3L)
[1] 59 45 41

# 每種編碼方式的BOM不同
# UTF-16LE(FF FE)
# UTF-16BE(FE FF)
# UTF-8(EF BB BF)
# 59 45 41當然無法判別

# 這個不是UTF-8編碼
> readLines(file(hospital_path, encoding = "UTF-8"), n = 6)
[1] "YEARYY,HOSPID,HOSPNAME,SPECIALNAME,CODE2,CODE3,CODE5,CODE8,CODE9,CODE10,CODE11,,"
[2] "100Q1,0501010019,"                

# 所以改成BIG5，done
> readLines(file(hospital_path, encoding = "BIG5"), n = 6)
[1] "YEARYY,HOSPID,HOSPNAME,SPECIALNAME,CODE2,CODE3,CODE5,CODE8,CODE9,CODE10,CODE11,,"                                               
[2] "100Q1,0501010019,三軍總醫院松山分院附設民眾診療服務處                        ,區域醫院            ,45.00,3.84,0.9777,1,9,n,,,"  
[3] "100Q1,3501013040,安禾聯合診所                                                ,診所                ,179.00,4.04,0.9385,2,22,n,,,"
[4] "100Q1,3501011313,安德聯合診所                                                ,診所                ,230.00,3.94,0.9478,3,29,n,,,"
[5] "100Q1,1101010012,長庚醫療財團法人台北長庚紀念醫院                            ,醫學中心            ,212.00,3.97,0.9858,2,25,n,,,"
[6] "100Q1,3501013326,祐腎內科診所                                                ,診所                ,46.00,3.98,0.9782,1,5,n,y,," 


# JS的substring(startIndex, endIndex)，不包含endIndex
# R: `substring("abc", 1, 2)` //"ab"
# 一長串的hospital$YEARYY是這些東西
# 100Q1 100Q1 100Q1 100Q1 100Q1 100Q1 100Q1...

> substring(head(hospital$YEARYY), 1, 3)
[1] "100" "100" "100" "100" "100" "100"

> yearyy <- as.character(hospital$YEARYY)
# > yearyy
# "100Q1" "100Q1" "100Q1" "100Q1" "100Q1" "100Q1" "100Q1"...
> class(yearyy)
[1] "character"

# 以"Q"當成分水嶺切割
> tmp <- strsplit(yearyy, "Q")
> class(tmp)
[1] "list"

> tmp[[2]]
[1] "100" "1"  

# 實際上要對每個 [[1到16000多]][1] 做處理因此 
# 100Q1 -> "100", "1" ，兩個欄位
> lapply(tmp, "[", 1)
> lapply(tmp, "[", 2)
# 然後跑出16000多筆資料..

> tmp2 <- lapply(tmp, "[", 1)
> unlist(tmp2)
# unlist(tmp2)密集地跑出資料，否則原本是「一筆一筆跑」
> class(tmp2)
[1] "list"
> class(unlist(tmp2))
[1] "character"

# 同unlist(tmp2)效果
> sapply(tmp, "[", 1)





# 下列習題放在RStudio上跑 
# 要先引入pirate_path這個海盜.txt資料

pirate_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-01-Parsing\\pirate-info-2015-09.txt"
# 首先，我們把該檔案載入到R 之中
pirate_info <- readLines(file(pirate_path, encoding = "BIG5"))

# 接著我們要把經緯度從這份資料中萃取出來
# 這份資料的格式，基本上可以用`：`分割出資料的欄位與內容

pirate_info_key_value <- {
  
  # .delim為取出冒號
  .delim <- strsplit(pirate_info[2], "")[[1]][3]
  
  strsplit(pirate_info, .delim)
}

# 我們需要的欄位名稱是「經緯度」
# 請同學先把`pirate_info_key_value`中每個元素（這些元素均為字串向量）的第一個值取出
# 你的答案鷹該要是字串向量
pirate_info_key <- {
  # 請在這邊填寫你的程式碼
  # 這個程式碼可以多行
  sapply(pirate_info_key_value, "[", 1)
}

# 確保你的結果是字串向量，否則答案會出錯
stopifnot(class(pirate_info_key) == "character")

# 我們將`pirate_info_key`和`"經緯度"`做比較後，把結果存到變數`pirate_is_coordinate`
# 結果應該為一個布林向量
pirate_is_coordinate <- {
  pirate_info_key == pirate_info_key[8]
}

# 確保你的結果是布林向量，否則答案會出錯
stopifnot(class(pirate_is_coordinate) == "logical")
# 應該總共有11件海盜通報事件
stopifnot(sum(pirate_is_coordinate) == 11)

# 接著我們可以利用`pirate_is_coordinate`和`pirate_info_key_value`
# 找出所有的經緯度資料
# 請把這個資料存到變數`pirate_coordinate_raw`中，並且是個長度為11的字串向量
pirate_coordinate_raw <- {
  .tmp <- sapply(pirate_info_key_value, "[", 2)
  .tmp[pirate_is_coordinate]
}

stopifnot(class(pirate_coordinate_raw) == "character")
stopifnot(length(pirate_coordinate_raw) == 11)

# 我們接著可以使用`substring`抓出經緯度的數字
# 請先抓出緯度並忽略「分」的部份
# 結果應該是整數（請用as.integer轉換）
pirate_coordinate_latitude <- {
  
  as.integer(substring(pirate_coordinate_raw, 3, 4))
}

stopifnot(class(pirate_coordinate_latitude) == "integer")
stopifnot(length(pirate_coordinate_latitude) == 11)

# 請用同樣的要領取出經度並忽略「分」的部份
# 結果同樣應該是整數
pirate_coordinate_longitude <- {
  
  as.integer(substring(pirate_coordinate_raw, 12, 14))
}

stopifnot(class(pirate_coordinate_longitude) == "integer")
stopifnot(length(pirate_coordinate_longitude) == 11)
stopifnot(sum(pirate_coordinate_longitude) == 1151)

pirate_df <- data.frame(
  latitude = pirate_coordinate_latitude,
  longitude = pirate_coordinate_longitude
)

stopifnot(is.data.frame(pirate_df))
stopifnot(nrow(pirate_df) == 11)
stopifnot(ncol(pirate_df) == 2)
stopifnot(class(pirate_df$latitude) == "integer")
stopifnot(class(pirate_df$longitude) == "integer")
stopifnot(sum(pirate_df$latitude) == 43)
stopifnot(sum(pirate_df$longitude) == 1151)