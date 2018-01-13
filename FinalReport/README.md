# 動機

### 利益

每到政治人物選舉年，滿天的廣告單、以及媒體間的口舌，以過去的政績或是質疑對方的背景影響民意。檯面上的行為可以透過新聞播報，，然而有多少訊息是真正可以量化檢視分析的。

在法案上背離民意，然而立委能夠不為所動的原因是甚麼？立委以為的民意，真正放在人民的權重有多少。亦或者是換個位置會換個腦袋，政商之間，裙帶關係在當局者的看待下是否比身為旁觀者的我們以為還重要？

---

### 變數

直覺來說，勝選與落選的人之間政治獻金比例是否有差距，

**而這次報告，獻金的限制範圍在營利事業上面**

1. 以前五大黨為族群，分別顯示其收到的獻金筆數、獻金總額的分布為何

2. 關於獻金筆數對於得票率以及獻金總額對於得票率做回歸
3. 順便檢視誰拿的錢很多結果還落選的，不符合效益的也要抓出來。

---

### 報告

以整體來看，當選立委所拿到的政治獻金會多於落選立委。

以捐獻企業觀點來看，贊助貢獻好辦事，捐獻能使得其企業經營較為通暢。因此，越是有機會當選或是挑戰連任的立委所收到的獻金會不成比例地多於其它尚在起步的新秀。

立委席次 113 席中，20%佔了全體政治獻金的 50%，若分母扣除不分區立委，其獻金的貧富差距會更高。

##### 獻金來源？

個人捐贈 / 營利事業 / 政黨捐贈 / 人民團體捐贈 / 匿名 / 其它，以前三大項來說：

* 起步的時代力量在個人捐贈佔總獻金比是 74.26%，民進黨將近 6 成，而國民黨只佔 3 成
* 營利事業捐贈，DPP 及 KMT 約 3 成多，時代力量約 16%。
* 政黨捐贈，DPP 及時代力量探向 1%，**KMT 來自政黨捐獻將近 36.32%是其獻金來源最大宗。**

# 資料來源

* [數讀政治獻金](https://www.mirrormedia.mg/projects/political-contribution/#/)
* [politicalcontribution](https://github.com/mirror-media/politicalcontribution)
* [政治選區愛你有多少](https://www.facebook.com/notes/claire-tsao/%E6%94%BF%E6%B2%BB%E7%8D%BB%E9%87%91%E4%B9%8B%E9%81%B8%E5%8D%80%E6%84%9B%E4%BD%A0%E6%9C%89%E5%A4%9A%E5%B0%91/1946938758655360/)
* [政治獻金：你掌握了小額捐款，然後呢？](https://medium.com/@austinwang_23988/%E6%94%BF%E6%B2%BB%E7%8D%BB%E9%87%91-%E4%BD%A0%E6%8E%8C%E6%8F%A1%E4%BA%86%E5%B0%8F%E9%A1%8D%E6%8D%90%E6%AC%BE-%E7%84%B6%E5%BE%8C%E5%91%A2-b61086e46e28)
  _比較企業公開支持、匿名支持、人民支持個別與得票率的關係_

# 結論

是否符合預期？模型解釋

### 前提說明：

* 選擇在已在立法院替人民服務的政黨：分別為中國國民黨、民主進步黨、時代力量、無黨團結聯盟以及無黨籍。
* 立委資料不包括不分區立委
* 無黨團結聯盟只有一個`高金素梅`參選並且當選，該黨人數當選率佔 100%。
* 無黨籍參選 15 人之中只有`趙正宇`當選，2014 年以無黨籍當選議員，之後獲得民進黨以及非藍營的支持選上立委。
* 時代力量四選三，洪慈庸、林昶佐、邱顯智、黃國昌，邱顯智落敗

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

**無黨團結聯盟不算，先前說明過他們只派一位參選並且當選**

---

# 所有參選人的獻金總額分布圖

```r
ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_grey() +
    geom_point() + scale_color_manual(values = cb7) + 
    geom_smooth(se = FALSE, method = "lm") +
    geom_abline(intercept = 1746139, slope = 109232)
```

![所有參選人的獻金分布圖](https://github.com/Jiaaa1014/R-/blob/master/FinalReport/imgs/32.png)

中下方的線條為總體平均獻金，獻金百分位以下：

```r
summary(eachPoliGet$獻金總額)
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
    1000  1891750  4379000  5675650  8142500 26915133
```
