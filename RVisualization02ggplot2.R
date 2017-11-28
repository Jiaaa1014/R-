# 沿用`hsb`資料

# 簡易的男女/學校類別表格
> tab1 <- table(hsb$sex, hsb$schtyp)
> tab1
        
         private public
  female      18     91
  male        14     77

# 男女數量堆積在學校類別上的直條圖
# `legend=TRUE`代表有標註男生女生的顏色
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


# 再將`dat2`轉換回表格型態，使用xtabs
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


