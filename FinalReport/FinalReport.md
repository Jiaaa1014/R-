

```r
  ggplot(eachPoliGet1, aes(獻金總額萬元)) + theme_gray()+ theme(aspect.ratio = 1 / 2) +
    geom_density(alpha = 0.5) + 
    geom_vline(xintercept = mean(eachPoliGet1$獻金總額萬元)) 
   
  density(eachPoliGet1$獻金總額萬元)
```
![捐獻金額密度圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/01.png)

![勝落敗所得獻金比例](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/07.png)

-------


### 所有參選人的獻金總額分布圖
```r
ggplot(eachPoliGet, aes(候選人, 獻金總額, color = 政黨)) + theme_grey() +
    geom_point(size = 2) + theme(legend.box.margin = margin(0, 0, 230, -100), axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values = cb7) + geom_hline(yintercept = mean(eachPoliGet$獻金總額))
```
![勝選一方在每黨所佔的人數比及獻金比](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/32.png)

-------
  


```r
  ggplot(eachPoliGet, aes(候選人, 獻金總額, color = isOnLine)) + 
    geom_point(size = 2) + theme(legend.box.margin = margin(0, 0, 70, -80), 
      legend.justification = c("right", "bottom"),  axis.text = element_blank(), 
      axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values = c("#787878", "#CB4042")) + facet_wrap( ~ 政黨) + labs(subtitle = "紅色為選上立委")
 ```
![所有參選人的獻金分布圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/33.png)

中下方的線條為總體平均獻金
```r
summary(eachPoliGet$獻金總額)
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    1000  1891750  4379000  5675650  8142500 26915133 
```

-------
### 捐贈數目對於獻金總額的回歸線
```r
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_grey() +
    geom_point() + scale_color_manual(values = cb7) + geom_smooth(se = FALSE, method = "lm") + 
    geom_abline(intercept = 1746139, slope = 109232)
``` 
![捐贈筆數對於獻金總額的影響](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/40.png)

| Coefficient | B0       |   B1   |
| :----------: | :-------: | :----: |
|  中國國民黨  | 1012165   | 173414 |
|  民主進步黨  | 2204964   | 92647  |
|   時代力量   | 933278    | 71176  |
| 無黨團結聯盟 | 1500000   |   NA   |
|    無黨籍    | -18373   | 152752 |   

政治獻金可以用來抵稅，對於企業來說，對單一參選人捐贈最多不超過10萬元，而捐獻扣除額不得超過當年度申報綜合所得總額的10%。
在反正捐了也沒有太大損失還可以抵稅的狀況下，一個企業捐100萬給一人也只能扣50萬，那麼捐給5人各20萬還可以意思意思賺賺人情。
民進黨在此張圖的回歸線低於總體回歸線，意即，政治獻金有其投機性，選舉當時風向看不看好是一大因素，無差別立場的企業當然是貢獻給可能會上的立委，所以民進黨以數量取勝。

民進黨參選人的總體營利事業捐獻筆數來看，前30名即佔了25個名額。

國民黨若以每筆捐贈平均來看的話，前30名之中佔了24位，然而民進黨只佔了4位，國民黨的斜率`B1`將近民進黨兩倍

企業當中最凱當屬遠東集團營利事業捐贈共5400萬無差別撒錢，第二名的裕隆集團捐獻給予國民黨人較多，而第三名的台泥捐獻予23名全都是國民黨員。
CP值低：一直想選台北市長的丁守中、以及吳育昇，林郁方、楊瓊瓔、楊麗環、廖正井皆錢多落馬。


-------
### 個別黨派其捐贈數目對於獻金總額的回歸線
```r
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_dark() +
    geom_point(size = 1.8) + scale_color_manual(values = cb7) + 
    geom_smooth(se = FALSE, method = "lm") + facet_wrap(~ 政黨, scales = "free") + 
    theme(panel.grid = element_blank())
 ```
![捐贈筆數對於獻金總額的影響 / 每黨](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/41.png)                            

將上一張圖分開來，除了藍綠兩黨以外的人太少，回歸意義不大。
