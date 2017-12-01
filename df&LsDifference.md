## Pick up data.frame selected data 


```R

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

gdp.df.components <- list()

for(i in 1:7) {
  
  start <- year.index.start[i]
  end <- year.index.end[i]

  year <- gdp.split[[start]] %>%
    # 年分資料的字串的奇怪符號，以空白換掉
    gsub(pattern = '"', replacement = '')
  # 喔喔喔以年度的index當作區間～～
  target <- gdp.split[start:end]
 
  target.mat <- do.call(rbind, 
                        target[sapply(target, length) == 3])
  
  target.mat[,1] <- year
  
  target.mat[,2] <- gsub('"', '', target.mat[,2])
 
  gdp.df.components[[i]] <- target.mat
}
gdp.df <- do.call(rbind, gdp.df.components) %>% 
  # 先不把資料轉成factor
  data.frame(stringsAsFactors = FALSE)

colnames(gdp.df) <- c("year", "name", "gdp")

gdp.df$year <- as.integer(gdp.df$year)
gdp.df$name <- as.character(gdp.df$name)
gdp.df$gdp <- as.numeric(gdp.df$gdp)


# 有出警告，中間有值被轉換成NA，過濾NA
gdp.df[is.na(gdp.df$gdp),]
gdp.df <- filter(gdp.df, !is.na(gdp))
```

We choose the variables `gdp.df` and `gdp.df.components` at the environment


## `gdp.df` 
#### `data.frame`
![gdp.df](images/gdp.df.png)

```R
# `data.frame`
# gdp.df[1], gdp.df[2] in the same way
> gdp.df[3]
         gdp
1     191886
2     139746
3      19357
4       1935
5      30848
6      21279
```

How to pick third data which is 19357？
```R
# `numeric`
> gdp.df[3][3,]
[1] 19357

> gdp.df[[3]][3]
[1] 19357
```
>
failed !
```R
> gdp.df[3][,3]
Error in `[.data.frame`(gdp.df[3], , 3) : undefined columns selected
```
>
We have only column.. so the range we chose is safe
```R
# `numeric`
> gdp.df[3][,1]
  [1]   191886   139746    19357     1935    30848    21279
  [7]  3916754    87316    63703    87878    28384    19082
  # ...
> gdp.df[[3]]
  [1]   191886   139746    19357     1935    30848    21279
  [7]  3916754    87316    63703    87878    28384    19082
  # ...
> gdp.df[,3]
  [1]   191886   139746    19357     1935    30848    21279
  [7]  3916754    87316    63703    87878    28384    19082
  # ...
```

```R
# `data.frame`
> gdp.df[1,]
  year               name    gdp
1 2007 A.農、林、漁、牧業 191886
> str(gdp.df[1:3,])
'data.frame':	3 obs. of  3 variables:
 $ year: int  2007 2007 2007
 $ name: chr  "A.農、林、漁、牧業" "AA.農耕業" "AB.畜牧業"
 $ gdp : num  191886 139746 19357
```

## `gdp.df.component`
#### `list`
![gdp.df.components](images/gdp.df.components.png)

##### Preview
```R
> str(gdp.df.components)
List of 7
 $ : chr [1:86, 1:3] "2007" "2007" "2007" "2007" ...
 $ : chr [1:86, 1:3] "2008" "2008" "2008" "2008" ...
 $ : chr [1:86, 1:3] "2009" "2009" "2009" "2009" ...
 $ : chr [1:86, 1:3] "2010" "2010" "2010" "2010" ...
 $ : chr [1:86, 1:3] "2011" "2011" "2011" "2011" ...
 $ : chr [1:86, 1:3] "2012" "2012" "2012" "2012" ...
 $ : chr [1:86, 1:3] "2013" "2013" "2013" "2013" ...
```
>
Simple !
```R
# `list`
> gdp.df.components[1]
[[1]]
      [,1]   [,2]                                [,3]      
 [1,] "2007" "A.農、林、漁、牧業"                "191886"  
 [2,] "2007" "AA.農耕業"                         "139746"  
 [3,] "2007" "AB.畜牧業"                         "19357"   
 [4,] "2007" "AC.林業"                           "1935"    
 [5,] "2007" "AD.漁業"                           "30848"   
 [6,] "2007" "B.礦業及土石採取業"                "21279"   
```
>
```R
# `matrix`
> gdp.df.components[5][[1]]
      [,1]   [,2]                                [,3]      
 [1,] "2011" "A.農、林、漁、牧業"                "245783"  
 [2,] "2011" "AA.農耕業"                         "179167"  
 [3,] "2011" "AB.畜牧業"                         "26704"   
 [4,] "2011" "AC.林業"                           "2018"    
 [5,] "2011" "AD.漁業"                           "37894"   
 [6,] "2011" "B.礦業及土石採取業"                "17174"   
 
 > gdp.df.components[5][[1]][1]
[1] "2011"
> gdp.df.components[5][[1]][88]
# gdp.df.components[[5]][88]
[1] "AA.農耕業"
 > gdp.df.components[5][[1]][87]
# gdp.df.components[[5]][87]
[1] "A.農、林、漁、牧業"

# the last one in 86 * 3 matrix
> gdp.df.components[5][[1]][258]
# gdp.df.components[[5]][258]
[1] "2128517"

> gdp.df.components[[4]]
      [,1]   [,2]                                [,3]      
 [1,] "2010" "A.農、林、漁、牧業"                "224828"  
 [2,] "2010" "AA.農耕業"                         "158291"  
 [3,] "2010" "AB.畜牧業"                         "30160"   
 [4,] "2010" "AC.林業"                           "1604"    
 [5,] "2010" "AD.漁業"                           "34773"   
 [6,] "2010" "B.礦業及土石採取業"                "18415"   
```
>
In the martix, we can use `[row, col]` method to take what we want.
```R
# `character`
> gdp.df.components[[4]][1,]
[1] "2010"               "A.農、林、漁、牧業"
[3] "224828"
> gdp.df.components[[4]][1,3]
[1] "224828"
 
```

gdp.df.components[[4]] == gdp.df.components[4][[1]]
> str(gdp.df.components[4][[1]])
 chr [1:86, 1:3] "2010" "2010" "2010" "2010" "2010" "2010" ...
> str(gdp.df.components[[4]])
 chr [1:86, 1:3] "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" "2010" ...
