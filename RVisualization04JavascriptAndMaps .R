# googleVis基於JavaScript來在網頁寫出資料圖表的簡易好用工具
# 可以讓對於R不熟悉的使用者也可以畫出圖表

# 安裝`googleVis`並且載入
> check_then_install(googleVis)
> library(googleVis)
# 打開參考文件
> vignette("googleVis_examples", package = "googleVis")
# 載入`dplyr`
> library(dplyr)


# 以族群性別分作8組計算數學平均
> dat1 <- group_by(hsb, race, sex) %>% summarise(math.avg = mean(math))
> dat1
# A tibble: 8 x 3
# Groups:   race [?]
              race    sex math.avg
            <fctr> <fctr>    <dbl>
1 African American female 47.53846
2 African American   male 45.28571
3            Asian female 56.75000
4            Asian   male 58.66667
5         Hispanic female 45.27273
6         Hispanic   male 49.23077
7            White female 53.77922
8            White   male 54.19118


# 建立`gvis`物件，打開是html網頁
> g <- gvisBarChart(dat1)

# 打開網頁顯示水平直條圖，滑鼠可以和圖表作互動
# `gvis`相較於`dplyr`是水平的
> plot(g)
# 但男性女性的顏色都是藍色！？ 


# 載入`reshape2`
> library(reshape2)
> dcast(dat1, race ~ sex)
Using math.avg as value column: use value.var to override.
              race   female     male
1 African American 47.53846 45.28571
2            Asian 56.75000 58.66667
3         Hispanic 45.27273 49.23077
4            White 53.77922 54.19118

# 男女性的顏色分開了
> dcast(dat1, race ~ sex) %>% gvisBarChart() %>% plot

# 簡易分布圖 
> select(hsb, read, math) %>% gvisScatterChart() %>% plot

# 連連看的接口權重
> dat_sk
  From To Weight
1    A  X      5
2    A  Y      7
3    A  Z      6
4    B  X      2
5    B  Y      9
6    B  Z      4
> gvisSankey(dat_sk) %>% plot()

# 利用`googleVis`提供的月曆API所繪製的圖，查詢每日台股指數
# 顏色深淺與指數高低成正相關
> gvisCalendar(TWII) %>% plot

# 組織圖，全球--亞歐美--個別地區國家列舉
> gvisOrgChart(Regions) %>% plot

# `ggmap`處理地圖資料的套件，下載並載入
> install.packages("ggmap")
> library(ggmap)


# 抓地圖，參數1是地點，參數2是範圍大小，(3, 21) -> (世界, 建築物)
> twmap <- try(get_map("Taiwan", 3, silent = TRUE))
# 上面失敗了換下面
> twmap <- readRDS(.get_path("twmap.Rds"))
> twmap
1280x1280 terrain map image from Google Maps.  see ?ggmap to plot it.

# 建立`ggplot`物件，建立畫板
# 到issues找解決脈絡
g <- ggmap(twmap, extent = "device")
錯誤: GeomRasterAnn was built with an incompatible version of ggproto.
Please reinstall the package that provides this extension.

# 把地震地點標上地圖
> g + geom_point(aes(longitude, latitude), eq)
# 點點依照地震規模調整大小
> g + geom_point(aes(longitude, latitude, size = mag), eq)

