


![各政黨的的獻金總額](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/00.png)

![捐獻金額密度圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/01.png)

![勝落敗所得獻金比例](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/07.png)

![勝選一方在每黨所佔的人數比及獻金比](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/32.png)

![所有參選人的獻金分布圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/33.png)


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

  
![捐贈筆數對於獻金總額的影響 / 每黨](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/41.png)                            
   
