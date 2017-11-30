# 使用到兩個檔案： power_path, NA8103A1Ac.csv
# `md5sum`檢查路徑與內容可以使用
> tools::md5sum(power_path)
C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\Project-ROpenData-Power-GDP\\power.txt 
                                                                                       "80c02601192e706d453a289a5e32c176" 
> tools::md5sum(gdp_path)
C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\Project-ROpenData-Power-GDP\\NA8103A1Ac.csv 
                                                                                            "9eee2ac49d017dbb79c8a802b55eb3bc" 


# 讀取一部分的開頭
> readLines(file(power_path, encoding = "BIG5"), n = 10)
# 存入變數
> power <- readLines(file(power_path, encoding = "BIG5"))

# 切割字串";?"代表分號可有可無，
> power.split <- strsplit(power, ";?\t")
> head(power.split, 1)
[[1]]
[1] "011"        "農藝及園藝" "87"         "113584956" 

# 丟到矩陣裏頭
> power.mat <- do.call(rbind, power.split)
> head(power.mat, 1)
     [,1]  [,2]         [,3] [,4]       
[1,] "011" "農藝及園藝" "87" "113584956"

# 變成`data.frame`形式，且順便改名
# `stringAsFactor = FALSE`以防欄位被改成`factor`
> power.df <- data.frame(power.mat, stringsAsFactors = FALSE)
> colnames(power.df) <- c("id", "name", "year", "power")
> head(power.df, 1)
   id       name year     power
1 011 農藝及園藝   87 113584956
Component “name”: Modes: character, numericComponent “name”: Attributes: < target is NULL, current is list >Component “name”: target is character, current is factor


# 把name變成`factor`
> power.df$name <- factor(power.df$name)
# 年分變成`integer`
> power.df$year <- as.integer(power.df$year)
> power.df$power <- as.numeric(power.df$power)
# integer和numeric有甚麼不同：https://stackoverflow.com/questions/23660094/whats-the-difference-between-integer-class-and-numeric-class-in-r

# 現在呼叫資料不會有下面奇怪的警告了(L43)
> head(power.df, 1)
   id       name year     power
1 011 農藝及園藝   87 113584956

# 乾乾淨淨
> all(!is.na(power.df))
[1] TRUE


> library(dplyr)
> library(ggplot2)


# 單一的農或林或牧都是以數字開頭
# 農、林、漁、牧合計的方式會以A標示
# id開頭是字母的正規表達式
> power.target <- filter(power.df, grepl("^[A-Z]", id))

# 只要91年度的所有行業
> power.target <- filter(power.df, grepl("^[A-Z]", id), year == 91)

> power.target
   id                     name year       power
1  A.     農、林、漁、牧業合計   91  2326157863
2  B.     礦業及土石採取業合計   91   367144361
3  C.               製造業合計   91 69696372915
4  D.       水、電、燃氣業合計   91  2253487304
5  E.               營造業合計   91   529889774
6  F.   批發、零售及餐飲業合計   91  6407122986
7  G.   運輸、倉儲及通信業合計   91  3239635057
8  H. 金融、保險及不動產業合計   91  1034684785
9  I.           工商服務業合計   91   653210656
10 J. 社會服務及個人服務業合計   91  7954239517
11 K.           公共行政業合計   91  2371472384
12 X.   其他不能歸類之行業合計   91  3601486761

# 行業為x軸，y軸為各行業的耗電量
> g <- ggplot(power.target, aes(name, power))

# x軸的字不夠放，倒著90度
> g +　geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90))

# `coord_polar`作為圓餅圖，`theta = "y"`以y值做為切割披薩的比例
> ggplot(power.target, aes(x = "", y = power, fill = name)) + geom_bar(stat = "identity") + coord_polar(theta = "y")
# 超明顯一半以上的電力耗用來自製造業，那GDP貢獻有成比例嗎？



# 另一筆GDP資料
> readLines(file(gdp_path, encoding = "BIG-5"), n = 20)
[1] "\"國內各業生產及平減指數(2008SNA)-年 依 期間, 行業, 指標 與 種類\""
 [2] ""                                                                  
 [3] "\" \",\" \",\" 國內生產毛額_當期價格(新台幣百萬元)\""              
 [4] "\" \",\" \",\"原始值\""                                            
 [5] "\"2007\""                                                          
 [6] "\" \",\"A.農、林、漁、牧業\",191886"                               
 [7] "\" \",\"AA.農耕業\",139746"                                        
 [8] "\" \",\"AB.畜牧業\",19357"                                         
 [9] "\" \",\"AC.林業\",1935"                                            
[10] "\" \",\"AD.漁業\",30848"                                           
[11] "\" \",\"B.礦業及土石採取業\",21279"                                
[12] "\" \",\"C.製造業\",3916754"                                        
[13] "\" \",\"CA.食品製造業\",87316"                                     
[14] "\" \",\"CB.飲料及菸草製造業\",63703"                               
[15] "\" \",\"CC.紡織業\",87878"                                         
[16] "\" \",\"CD.成衣及服飾品製造業\",28384"                             
[17] "\" \",\"CE.皮革、毛皮及其製品製造業\",19082"                       
[18] "\" \",\"CF.木竹製品製造業\",10083"                                 
[19] "\" \",\"CG.紙漿、紙及紙製品製造業\",45182"                         
[20] "\" \",\"CH.印刷及資料儲存媒體複製業\",38652"                   


# 上面醜醜的
> cat(readLines(file(gdp_path, encoding = "BIG-5"), n = 20), sep = "\n")
# 載入`magrittr`
> library(magrittr)
# 可以把上一步亂亂的指令用pipe operator傳下去
> file(gdp_path, encoding = "BIG-5") %>% readLines(n = 20) %>% cat(sep = "\n")
"國內各業生產及平減指數(2008SNA)-年 依 期間, 行業, 指標 與 種類"

" "," "," 國內生產毛額_當期價格(新台幣百萬元)"
" "," ","原始值"
"2007"
" ","A.農、林、漁、牧業",191886
" ","AA.農耕業",139746
" ","AB.畜牧業",19357
" ","AC.林業",1935
" ","AD.漁業",30848
" ","B.礦業及土石採取業",21279
" ","C.製造業",3916754
" ","CA.食品製造業",87316
" ","CB.飲料及菸草製造業",63703
" ","CC.紡織業",87878
" ","CD.成衣及服飾品製造業",28384
" ","CE.皮革、毛皮及其製品製造業",19082
" ","CF.木竹製品製造業",10083
" ","CG.紙漿、紙及紙製品製造業",45182
" ","CH.印刷及資料儲存媒體複製業",38652


# 使用`readLines()`存入變數
> gdp <- file(gdp_path, encoding = "BIG5") %>% readLines
# 以逗點切割，結果要和上面比對清楚！！
> gdp.split <- strsplit(gdp, ",")
> head(gdp.split <- strsplit(gdp, ","))
[[1]]
[1] "\"國內各業生產及平減指數(2008SNA)-年 依 期間" " 行業"                                       
[3] " 指標 與 種類\""                             

[[2]]
character(0)

[[3]]
[1] "\" \""                                    "\" \""                                   
[3] "\" 國內生產毛額_當期價格(新台幣百萬元)\""

[[4]]
[1] "\" \""      "\" \""      "\"原始值\""

[[5]]
[1] "\"2007\""

[[6]]
[1] "\" \""                  "\"A.農、林、漁、牧業\"" "191886"                


# gdp.split[[1]], [[2]], ..., [[624]]這樣找下去的意思
這幾個得出來的數字就是長度為1的list index
> (sapply(gdp.split, length) == 1) %>% which
 [1]   5  92 179 266 353 440 527 615 616 617 618 619 620 621 622 623 624

把這17個index挑出來
> gdp.split[(sapply(gdp.split, length) == 1) %>% which]
[[1]]
[1] "\"2007\""

[[2]]
[1] "\"2008\""

[[3]]
[1] "\"2009\""

[[4]]
[1] "\"2010\""

[[5]]
[1] "\"2011\""

[[6]]
[1] "\"2012\""

[[7]]
[1] "\"2013\""

[[8]]
[1] "\"*年增率係以所取得資料之原始精確位數進行計算，與資料發布機關公布之結果-\""

[[9]]
[1] "\"容或有尾差。 \""

[[10]]
[1] "\"(http://www.stat.gov.tw/lp.asp?ctNode=2404&CtUnit=1088&BaseDSD=7) \""

[[11]]
[1] "\"more \""

[[12]]
[1] "\"(http://www.stat.gov.tw/lp.asp?CtNode=1831&CtUnit=927&BaseDSD=7&xq_xC-\""

[[13]]
[1] "\"at=10) 統計專題分析 \""

[[14]]
[1] "\"(http://www.stat.gov.tw/lp.asp?CtNode=1829&CtUnit=690&BaseDSD=7&xq_xC-\""

[[15]]
[1] "\"at=17) 國情統計通報 \""

[[16]]
[1] "\"96~101年資料已依5年修正結果追溯修正。 \""

[[17]]
[1] "\" \""

# 上面結果前七個都是西元年
year.index <- (sapply(gdp.split, length) == 1) %>% which %>% head(7)
> year.index
[1]   5  92 179 266 353 440 527










#################################################
library(ggplot2)
library(dplyr)

gdp_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\Project-ROpenData-Power-GDP\\NA8103A1Ac.csv"
gdp <- file(gdp_path, encoding = "BIG5") %>% readLines


gdp.split <- strsplit(gdp, ",")
year.index <- (sapply(gdp.split, length) == 1) %>% which %>% head(7)

# 開始的index
year.index.start <- year.index
# 全部往後退一位，少一個就拿總長度 = 625這個數值補
year.index.end <- c(tail(year.index, -1), length(gdp.split))

# 這句我不懂
gdp.df.components <- list()

# 請填寫正確的for 迴圈的範圍
for(i in 1:7) {
  
  # 開始的index
  start <- year.index.start[i]
  # 結束的index
  end <- year.index.end[i]
  ## 年份的資料在上述範圍中的第一筆
  year <- gdp.split[[start]] %>%
    # 年分資料的字串的奇怪符號，以空白換掉
    gsub(pattern = '"', replacement = '')
  # 喔喔喔以年度的index當作區間～～
  target <- gdp.split[start:end]
  # 挑出長度是3 的，做rbind上下堆疊
  target.mat <- do.call(rbind, 
                        target[sapply(target, length) == 3])
  # 原本的第一行是空白，我們改成放年份
  target.mat[,1] <- year
  ## 處理第二行中的職業類別字串的奇怪符號"
  target.mat[,2] <- gsub('"', '', target.mat[,2])
  ## 將這輪處理的資料，放到gdp.df.components
  gdp.df.components[[i]] <- target.mat
}
gdp.df <- do.call(rbind, gdp.df.components) %>% 
  # 先不把資料轉成factor
  data.frame(stringsAsFactors = FALSE)
colnames(gdp.df) <- c("year", "name", "gdp")

gdp.df$year <- as.integer(gdp.df$year)
gdp.df$name <- as.character(gdp.df$name)
gdp.df$gdp <- as.numeric(gdp.df$gdp)


## 有出警告，中間有值被轉換成NA，查詢NA的資料
gdp.df[is.na(gdp.df$gdp),]
## 拿掉它
gdp.df <- filter(gdp.df, !is.na(gdp))
#################################################
