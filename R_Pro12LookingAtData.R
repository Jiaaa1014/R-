# 事先儲存資料，`ls()`可以查看
# data.frame是常見的資料格式
> class(plants)
[1] "data.frame"

# 5166個觀察值(observations)，10個變數(variables)
> dim(plants)
[1] 5166   10

# 拆分為
> nrow(plants)
[1] 5166
> ncol(plants)
[1] 10

# 好奇這dataset佔用了多少記憶體
> object.size(plants)
644232 bytes

# 回傳a character vector of column
> names(plants)
 [1] "Scientific_Name"      "Duration"             "Active_Growth_Period"
 [4] "Foliage_Color"        "pH_Min"               "pH_Max"              
 [7] "Precip_Min"           "Precip_Max"           "Shade_Tolerance"     
[10] "Temp_Min_F"          

# 預設是前6筆，但第2個參數可以設定要前10筆
> head(plants, 10)

# 有些資料都是NA，是R語言的placeholders給那些消失的值

# 使用`summary()`可以知道資料裡面變數的`Min`, `Max`, `1st quartile`, `mean`, `median`, `3rd quartile`等等
> summary(plants)
 Scientific_Name                               Duration   
 Asplenium \xc3 rudellii  :   1   Perennial        :3031  
 Salix \xc3 endulina      :   1   Annual           : 682  
 Viola \xc3 rauniae       :   1   Annual, Perennial: 179  
 Castanea \xc3 eglecta    :   1   Annual, Biennial :  95  
 Salix \xc3 epulcralis    :   1   Biennial         :  57  
 Dryopteris \xc3 lossoniae:   1   (Other)          :  92  
 (Other)                  :5160   NA's             :1030  
           Active_Growth_Period      Foliage_Color      pH_Min          pH_Max      
 Spring and Summer   : 447      Dark Green  :  82   Min.   :3.000   Min.   : 5.100  
 Spring              : 144      Gray-Green  :  25   1st Qu.:4.500   1st Qu.: 7.000  
 Spring, Summer, Fall:  95      Green       : 692   Median :5.000   Median : 7.300  
 Summer              :  92      Red         :   4   Mean   :4.997   Mean   : 7.344  
 Summer and Fall     :  24      White-Gray  :   9   3rd Qu.:5.500   3rd Qu.: 7.800  
 (Other)             :  30      Yellow-Green:  20   Max.   :7.000   Max.   :10.000  
 NA's                :4334      NA's        :4334   NA's   :4327    NA's   :4327    
   Precip_Min      Precip_Max         Shade_Tolerance   Temp_Min_F    
 Min.   : 4.00   Min.   : 16.00   Intermediate: 242   Min.   :-79.00  
 1st Qu.:16.75   1st Qu.: 55.00   Intolerant  : 349   1st Qu.:-38.00  
 Median :28.00   Median : 60.00   Tolerant    : 246   Median :-33.00  
 Mean   :25.57   Mean   : 58.73   NA's        :4329   Mean   :-22.53  
 3rd Qu.:32.00   3rd Qu.: 60.00                       3rd Qu.:-18.00  
 Max.   :60.00   Max.   :200.00                       Max.   : 52.00  
 NA's   :4338    NA's   :4338                         NA's   :4328    


# Is that possible mean is greater than 3rd percentile?
# 太多小筆的資料
> x <- c(0,0,0,0,0,0,0,0,0,0,0,0,1)
> summary(x)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.00000 0.00000 0.00000 0.07692 0.00000 1.00000 

# 將其中一個變數以`table`方式呈現`level`
> table(plants$Active_Growth_Period)

Fall, Winter and Spring                  Spring         Spring and Fall 
                     15                     144                      10 
      Spring and Summer    Spring, Summer, Fall                  Summer 
                    447                      95                      92 
        Summer and Fall              Year Round 
                     24                       5 

# `str()`是`structure`不是`string`
# `str()`這東西好用，function, object...
> str(plants)
'data.frame':   5166 obs. of  10 variables:
 $ Scientific_Name     : Factor w/ 5166 levels "Asplenium \xc3rudellii",..: 55 56 57 58 59 60 61 62 63 64 ...
 $ Duration            : Factor w/ 8 levels "Annual","Annual, Biennial",..: NA 4 NA 7 7 NA 1 NA 7 7 ...
 $ Active_Growth_Period: Factor w/ 8 levels "Fall, Winter and Spring",..: NA NA NA 4 NA NA NA NA 4 NA ...
 $ Foliage_Color       : Factor w/ 6 levels "Dark Green","Gray-Green",..: NA NA NA 3 NA NA NA NA 3 NA ...
 $ pH_Min              : num  NA NA NA 4 NA NA NA NA 7 NA ...
 $ pH_Max              : num  NA NA NA 6 NA NA NA NA 8.5 NA ...
 $ Precip_Min          : int  NA NA NA 13 NA NA NA NA 4 NA ...
 $ Precip_Max          : int  NA NA NA 60 NA NA NA NA 20 NA ...
 $ Shade_Tolerance     : Factor w/ 3 levels "Intermediate",..: NA NA NA 3 NA NA NA NA 2 NA ...
 $ Temp_Min_F          : int  NA NA NA -43 NA NA NA NA -13 NA ...

