# 動機

### 利益

每到政治人物選舉年，滿天的廣告單、以及媒體間的口舌，以過去的政績或是質疑對方的背景影響民意。檯面上的行為可以透過新聞播報，，然而有多少訊息是真正可以量化檢視分析的。

在法案上背離民意，然而立委能夠不為所動的原因是甚麼？立委以為的民意，真正放在人民的權重有多少。亦或者是換個位置會換個腦袋，政商之間，裙帶關係在當局者的看待下是否比身為旁觀者的我們以為還重要？

---

### 變數

直覺來說，勝選與落選的人之間政治獻金比例是否有差距，

**而這次報告，獻金的限制範圍在營利事業上面**

1. 以前五大黨為族群，分別顯示其收到的獻金筆數、獻金總額的分布為何
2. 關於獻金筆數對於獻金總額做回歸
3. 以是否勝選`isOnline`以及以中國國民黨`isBlue`，這兩項為Dummy Variable
4. 順便檢視誰拿的錢很多結果還落選的，不符合效益的也要抓出來。

---

### 報告提要

##### 獻金的貧富差距

整體來看，當選立委所拿到的政治獻金會多於落選立委。

以捐獻企業觀點來看，贊助貢獻好辦事，捐獻能使得其企業經營較為通暢。
因此，越是有機會當選或是挑戰連任的立委所收到的獻金會不成比例地多於其它尚在起步的新秀。

立委席次 113 席中，20%佔了全體政治獻金的 50%，若分母扣除不分區立委，其獻金的貧富差距會更高。

##### 獻金來源？

個人捐贈 / 營利事業 / 政黨捐贈 / 人民團體捐贈 / 匿名 / 其它，以前三大項來說：

* 起步的時代力量在個人捐贈佔總獻金比是 74.26%，民進黨將近 6 成，而國民黨只佔 3 成
* 營利事業捐贈，DPP 及 KMT 約 3 成多，時代力量約 16%。
* 政黨捐贈，DPP 及時代力量探向 1%，**KMT 來自政黨捐獻將近 36.32%是其獻金來源最大宗。**

# 主軸

是否符合預期？

#### 前提說明：
* 使用`stringi`, `dplyr`, `magrittr`, `ggplot2`四個套件。
* 選擇在已在立法院替人民服務的政黨：分別為中國國民黨、民主進步黨、時代力量、無黨團結聯盟以及無黨籍。
* 立委資料不包括不分區立委。
* 無黨團結聯盟只有一個`高金素梅`參選並且當選，該黨人數當選率佔 100%。
* 無黨籍參選 15 人之中只有`趙正宇`當選，2014 年以無黨籍當選議員，之後獲得民進黨以及非藍營的支持選上立委。
* 時代力量四選三，洪慈庸、林昶佐、邱顯智、黃國昌，邱顯智落敗。
* **比到後面資料越來越精簡，最後只剩兩大黨。**

##### 勝選落選兩樣情

```r
ggplot(winOrLoseGet,aes("", 該結果比例, fill = isOnLine)) +
    geom_bar(stat = "identity", alpha = 0.8) +
    coord_polar(theta = "y") + scale_fill_manual(values = c("#787878","#CB4042")) +
    labs(title ="勝選一方的獻金大約佔了七成", x = "", y = "")
```

![勝落敗所得獻金比例](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/07.png)

---

##### 勝選人在該黨所佔的人數比及獻金比

```r
ggplot(eachPoliGet, aes(候選人, 獻金總額, color = 政黨)) + theme_grey() +
    geom_point(size = 2) + 
    theme(legend.box.margin = margin(0, 0, 230, -100), axis.text = element_blank(), 
        axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values = cb7) + geom_hline(yintercept = mean(eachPoliGet$獻金總額))
```

![勝選一方在每黨所佔的人數比及獻金比](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/22.png)

**紅色那條為無黨團結聯盟沒有意義，先前說明過他們只派一位高金素梅參選並且當選**，之後會過濾掉

---

##### 所有參選人的獻金總額分布圖

```r
ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_grey() +
    geom_point() + scale_color_manual(values = cb7) + 
    geom_smooth(se = FALSE, method = "lm") +
    geom_abline(intercept = 1746139, slope = 109232)
```

![所有參選人的獻金分布圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/32.png)

那一條橫軸為每位參選人算出的獻金平均

![當選的獻金分布圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/31.png)

其實立委年薪為230萬，加上其他的立委補助、保險和事務費，大概將近360萬元。

不過選舉一次金流量遠遠大過於薪水，獻金的背後，是權力，是政商關係的賭注。

獻金百分位如下：

```r
summary(eachPoliGet$獻金總額)
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
    1000  1891750  4379000  5675650  8142500 26915133
```

---
##### 捐贈數目對於獻金總額的回歸線

```r
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_grey() +
    geom_point() + scale_color_manual(values = cb7) + 
    geom_smooth(se = FALSE, method = "lm") +
    geom_abline(intercept = 1746139, slope = 109232)
```

![捐贈筆數對於獻金總額的影響](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/40.png)

| Coefficient  |    B0     |   B1   |
| :----------: | :-------: | :----: |
|  中國國民黨  | 1012165   | 173414 |
|  民主進步黨  | 2204964   | 92647  |
|   時代力量   | 933278    | 71176  |
| 無黨團結聯盟 | 1500000   |   NA   |
|    無黨籍    |  -18373   | 152752 |

政治獻金可以用來抵稅，對於企業來說，對單一參選人捐贈最多不超過 10 萬元，而捐獻扣除額不得超過當年度申報綜合所得總額的 10%。在反正捐了也沒有太大損失還可以抵稅的狀況下，一個企業捐 100 萬給一人也只能扣 50 萬，那麼捐給 5 人各 20 萬還可以意思意思賺賺人情。民進黨在此張圖的回歸線低於總體回歸線，意即，政治獻金有其投機性，選舉當時風向看不看好是一大因素，無差別立場的企業當然是貢獻給可能會上的立委，所以民進黨以數量取勝。

* 民進黨參選人的總體營利事業捐獻筆數來看，前 30 名即佔了 25 個名額。

* 國民黨若以每筆捐贈平均來看的話，前 30 名之中佔了 24 位，然而民進黨只佔了 4 位，國民黨的斜率`B1`將近民進黨兩倍

* 企業當中最凱當屬遠東集團營利事業捐贈共 5400 萬無差別撒錢，第二名的裕隆集團捐獻給予國民黨人較多，
* 而第三名的台泥捐獻予 23 名全都是國民黨員，其他如金鼎證券集團、大慶集團也壓倒性偏向國民黨。
* 建新、力麗集團以及在高雄有環境爭議的日月光集團大多捐獻予民進黨員居多。
* CP 值低：一直想選台北市長的丁守中、以及吳育昇，林郁方、楊瓊瓔、楊麗環、廖正井皆拿得多最後落馬。

---

##### 若以結果勝選`isOnLine`以及是否為藍營`isBlue`當虛擬變數

扣除無黨團結聯盟(反正也才上一席)，無黨籍同前理由、時代力量僅四位參選人。後來其實在分區立委方面還是剩下藍綠兩黨的競爭，其他黨也因數量太小，影響程度不大，在這裡去除掉：

|  X  | isOnLine | isBlue |
|:---:| :-------:| :----: |
|  1  | 選上 | 國民黨 |
|  0  | 落選 | 民進黨  |


```r
twoParties <- filter(eachPoliGet, 政黨 == "中國國民黨" | 政黨== "民主進步黨") %>%
  mutate(isBlue = as.numeric(政黨 == "中國國民黨"),isOnLine = ifelse(isOnLine, 1,0))
```
```r

  lm(獻金總額 ~ 捐贈筆數 + isOnLine + isBlue, twoParties)
  # Coefficients:
  # (Intercept)     捐贈筆數     isOnLine       isBlue  
  #     -475102       109559      2081777      2370359  
  
  lm(獻金總額 ~ 捐贈筆數 + isBlue, twoParties)
  # Coefficients:
  # (Intercept)      捐贈筆數       isBlue  
  #      932901       114741      1519558  
  
  ## 若先看身為藍營對捐贈筆數的影響
  lm(捐贈筆數 ~ isBlue, twoParties)
  # Coefficients:
  #   (Intercept)       isBlue  
  #         57.57       -33.03 
  
  ## 再將捐贈筆數的變數抽掉，則身為藍營的負向力變大
  lm(獻金總額 ~ isBlue, twoParties)
  # Coefficients:
  # (Intercept)       isBlue  
  #     7538993     -2269870  
  
  ## 然而捐贈筆數對於最後的總額而言，其變化程度與上面另外兩個虛擬變數相比而言穩定
  lm(獻金總額 ~ 捐贈筆數, twoParties)
  # Coefficients:
  # (Intercept)      捐贈筆數  
  #     2163102       104576  
```

將兩項虛擬變數對`捐贈比數`及`獻金總額`做比較
發現與上述的捐贈筆數v.s獻金總額的回歸分布的解釋相同，綠營在相對捐贈數目上取勝

```r  
  lm(捐贈筆數 ~ isBlue + isOnLine, twoParties)
  # Coefficients:
  # (Intercept)       isBlue     isOnLine  
  #       47.19       -26.81        12.66  
  
  lm(獻金總額 ~ isBlue + isOnLine, twoParties)
  # Coefficients:
  # (Intercept)       isBlue     isOnLine  
  #     4695485      -566882      3469080  
``` 

將兩虛擬變數做比較，其為身為藍營參選人造成將近50%負向影響勝敗選
```r  
  lm(isOnLine ~ isBlue , twoParties)
  #  Coefficients:
  #  (Intercept)       isBlue  
  #       0.8197      -0.4909  
```

##### 個別黨派其捐贈數目對於獻金總額的回歸線

```r
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_dark() +
    geom_point(size = 1.8) + scale_color_manual(values = cb7) +
    geom_smooth(se = FALSE, method = "lm") + facet_wrap(~ 政黨, scales = "free") +
    theme(panel.grid = element_blank())
```

![捐贈筆數對於獻金總額的影響 / 每黨](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/41.png)

將上一張圖分開來，除了藍綠兩黨以外的人太少，回歸意義不大。

---

# 資料來源

* [數讀政治獻金](https://www.mirrormedia.mg/projects/political-contribution/#/)
* [politicalcontribution](https://github.com/mirror-media/politicalcontribution)
* [政治選區愛你有多少](https://www.facebook.com/notes/claire-tsao/%E6%94%BF%E6%B2%BB%E7%8D%BB%E9%87%91%E4%B9%8B%E9%81%B8%E5%8D%80%E6%84%9B%E4%BD%A0%E6%9C%89%E5%A4%9A%E5%B0%91/1946938758655360/)
* [政治獻金：你掌握了小額捐款，然後呢？](https://medium.com/@austinwang_23988/%E6%94%BF%E6%B2%BB%E7%8D%BB%E9%87%91-%E4%BD%A0%E6%8E%8C%E6%8F%A1%E4%BA%86%E5%B0%8F%E9%A1%8D%E6%8D%90%E6%AC%BE-%E7%84%B6%E5%BE%8C%E5%91%A2-b61086e46e28)
  _比較企業公開支持、匿名支持、人民支持個別與得票率的關係_


