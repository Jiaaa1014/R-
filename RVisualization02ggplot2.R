# 沿用`hsb`資料

# 簡易的男女/學校類別表格
> tab1 <- table(hsb$sex, hsb$schtyp)
> tab1
        
         private public
  female      18     91
  male        14     77

# 男女數量堆積在學校類別上的直條圖
# `legend=TRUE`代表有標註男生女生的圖例
> barplot(tab1, legend=TRUE)
# `beside=TRUE`，不要男女堆疊，分開表示
# `args.lenged`為(x, y)座標，且是跟著資料的度量衡當標準的
> barplot(tab1, legend=TRUE, beside=TRUE, args.legend=list(x=3, y=120))

# 載入`dplyr`套件
> library(dplyr)


# 以tb1當分4組個別的數學平均
> dat2 <- summarise(group_by(hsb, sex, schtyp), math.avg=mean(math))
> dat2
# A tibble: 4 x 3
# Groups:   sex [?]
     sex  schtyp math.avg
  <fctr>  <fctr>    <dbl>
1 female private 53.44444
2 female  public 52.18681
3   male private 56.42857
4   male  public 52.31169
> class(dat2)
[1] "grouped_df" "tbl_df"     "tbl"        "data.frame"


# 再將`dat2`轉換回表格型態，使用`xtabs()`
> tab2 <- xtabs(formula = math.avg ~ sex + schtyp , data = dat2)
> tab2
        schtyp
sex       private   public
  female 53.44444 52.18681
  male   56.42857 52.31169
> class(tab2)
[1] "xtabs" "table"
# > class(tab1)
# [1] "table"

# y軸的值在50-58之間，而超過x軸的直接消失
> barplot(tab2, beside = TRUE, ylim = c(50, 58), xpd = FALSE)


# 以種族分類計算他們閱讀成績中位數
> dat3 <- summarise(group_by(hsb, race), read.med=median(read))
> dat3
# A tibble: 4 x 2
              race read.med
            <fctr>    <dbl>
1 African American       47
2            Asian       52
3         Hispanic       47
4            White       54
> class(dat3)
[1] "tbl_df"     "tbl"        "data.frame"
# `horiz=TRUE`使得長條圖變成水平的
> barplot(dat3$read.med, names.arg = dat3$race, horiz = TRUE)

# 點標圖，很可愛～很像某個點點在跑短跑的腳程
> dotchart(dat3$read.med, labels = dat3$race)

# 原始`plot()`支援箱形圖
# `plot(y ~ x, data)`
> plot(math ~ race, data=hsb)

# 但是現在有`boxplot()`可以用了！！
# `col`還可以指定顏色
> boxplot(math ~ schtyp, data=hsb, col=c("darkblue", "gold"))
# 新增圖例
> legend("topleft", c("private", "public"), fill=c("darkblue", "gold"))


# 散佈圖
> plot(x=hsb$math, y=hsb$read)
# 等於(但xy軸標示不同)
> plot(read ~ math, data=hsb)
# 等於(xy對調)
> plot(~ read + math, data=hsb)

# 互相配對4*4格12組資料，參考R/images
> plot(~read+math+science+socst,data=hsb, main="HSB score")


> col.sex <- ifelse(hsb$sex=="male", "#e34a3355", "#2c7fb855")
> pch.schtyp <- ifelse(hsb$schtyp=="public", 1, 19)
> cex.science <- (hsb$science-25)/(50)*5

# 重點來了，參考R/images
> plot(~read+math, data=hsb, col=col.sex, pch=pch.schtyp, cex=cex.science)
# col得到的是男生給藍色女生給粉色
# pch設定是資料點的圖案，1代表空心圓，19代表實心圓
# cex代表的是scale，要放大多少倍
# 這三個參數分別得到字串,字串,數字向量
