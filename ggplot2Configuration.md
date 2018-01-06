下列筆記參考於：[這](blog.csdn.net/bone_ace/article/details/4742745a)

圖形資料是 x, y = A, B，設定文字來源，調整位置及角度
```r
geom_text(aes(label = B, vjust = 1.1, hjust = -0.5, angle = 45), show_guide = FALSE) 
```
兩種都是設定x刻度
```r
scale_x_continuous(limits = c(-5,15))
xlim(-5,15)
```
軸及標題
```r
xlab("at x") + ylab("at y") + ggtitle("main title")
# 等同於
labs(x = "at x", y = "at y", title = "main title")

```
進一步修改其標籤的樣式
```r
theme(axis.title.x = element_text(size = 15, family = "myFont", color = "green", face = "bold", vjust = 0.5, hjust = 0.5, angle = 45))
```
進一步修改x軸刻度標籤的樣式
```r
theme(axis.text.x = element_text(size = 15, family = "myFont", color = "green", face = "bold", vjust = 0.5, hjust = 0.5, angle = 45))
```

刪除背景網格
```r
theme(panel.grid =element_blank())
```
刪除刻度標籤
```r
theme(axis.text = element_blank())
```
刪除刻度線
```r
theme(axis.ticks = element_blank())
```
刪除外邊框
```r
theme(panel.border = element_blank()
```
但是要x,y軸
```r
theme(axis.line = element_line(size=1, colour = "black"))
```
9種主題
```r
theme_gray()
theme_bw()
theme_linedraw()
theme_light()
theme_dark()
theme_minimal()
theme_classic()
theme_void()
theme_test()
```
