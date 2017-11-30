# http://docs.ggplot2.org

# 兩種方法安裝，並且載入`ggplot2`
# check_then_install("ggplot2", "2.0.0")
> install.packages("ggplot2")
> library(ggplot2)


# 建立物件，建立畫板，x軸為教育時間區分
> g <- ggplot(infert, aes(x = education))

# 畫上直條圖
> g + geom_bar()
# 之所以先建立`g`物件，是因為這個物件裡面的東西可以傳入`geom_bar()`的參數
# `infert`傳入`geom_bar()`第2個`data`參數，`aes()`傳入第1個`mapping`參數

# 使用`fill`預設調色盤找到`education`填色
> g + geom_bar(aes(fill = education))

# `infert`裡面沒有欄位的值是`purple`，只好用預設調色的填滿
> g + geom_bar(aes(fill = "purple"))


# 新畫板
g <- ggplot(hsb)
# 只有灰階的長條圖
> g + geom_bar(aes(x = sex))
# 以`race`因子來做顏色區別，x軸為性別
g + geom_bar(aes(x = sex, fill = race))
# `position = "stack"`是預設值，y軸數量以堆疊方式
# `dodge`為錯開，兩個性別的族群分開計算，總共8條
> g + geom_bar(aes(sex, fill = race), position = "dodge")

# 載入套件
> library(dplyr)
#################################################
answer01 <- local({
  group_by(hsb, sex) %>%
    summarise(count = n())
})
#################################################


> answer01
# A tibble: 2 x 2
     sex count
  <fctr> <int>
1 female   109
2   male    91

# 先暫時別管`ggplot()`
# `geom_bar()`的`mapping`參數由`aes()`來完成
# aes可以放甚麼？
# `x, y, fill, group, size ,color, alpha, linetype`

# 起初沒有設置y的單位以至於y軸呈現男女皆是1
> ggplot(answer01, aes(sex)) + geom_bar()
# 設置y要放甚麼因子
# `geom_bar()`前2參數前面的`ggplot()`以給予
#             第3參數`stat`遇到問題了，之前沒有需要這個是因為只要count一個x因子
#             因為x, y 都有資料的關係，所以才需要這個"identity"值
#             告訴我們說，只要拿y的值當作結果就行
> ggplot(answer01, aes(x = sex, y = count)) + geom_bar(stat = "identity")

# 單調的數學成績密度圖
> ggplot(hsb, aes(x = math)) + geom_density()
# `x = math`簡化成`math`，兩條密度圖分別為男生女生的數學成績
> ggplot(hsb, aes(math, color = sex)) + geom_density()
# 族群的閱讀成績密度圖
> ggplot(hsb, aes(read, color = race)) + geom_density()


# 性別、學校類別為分類計算數學成績
> dat2 <- summarise(group_by(hsb, sex, schtyp), math.avg = mean(math))
> g <- ggplot(dat2, aes(sex, math.avg, fill = schtyp))
# 4條長條
> g2 <- g + geom_bar(stat = "identity", position = "dodge")
# 限定y軸值，讓比較更明顯
> g2 + coord_cartesian(ylim=c(40,60))

# `dotchart`對應到`ggplot2`的`geom_point()`
# `size`放`aes()`中會沒有反應，只是要外部確認點點尺寸和`aes()`無關
# 在L102，是因為`size`變動是與自然成績有關係得所以放在`aes()`裏頭 
> g3 <- g + geom_point(aes(color = schtyp), size = 10)
# 水平呈現
> g3 + coord_flip()

# `boxplot`對應到`ggplot2`的`geom_boxplot`
> g <- ggplot(hsb, aes(sex, math, fill = schtyp))
# `position = "dodge"`是預設，箱形圖自動分開
> g + geom_boxplot()
# 再以族群分別，醜醜的很多boxes
> g + geom_boxplot(aes(linetype = race))

# 先建立物件x為數學，y為閱讀的散佈圖
> g <- ggplot(hsb, aes(math, read))
# 黑色點點圖，最一般的那種
> g + geom_point()
# 參照 R/images/RVisualization03ggplot2-1.png
# science成績越高，圖例越大；以圖例作為公私立學校；以顏色作為性別分辨
# 參照 R/images/RVisualization03ggplot2-1.png
> g + geom_point(aes(size = science, pch = schtyp, color = sex))


# 自己做調色
> cb7 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# 試看看預設版本
> g <- ggplot(hsb, aes(sex, fill = race)) + geom_bar()
# 使用`scale_fill_manual()`來改
> g + scale_fill_manual(values=cb7)
# 轉換顏色風格
> g + theme_minimal()


# 暫存檔路徑
> dst <- tempfile(fileext = ".png")
> ggsave(dst)

# 其實可以直接命名儲存，存到的是當前使用資料夾，以`getwd()`查詢
> ggsave("name.png")


# 對每個族群都做一張，共4張
# 參照 R/images/RVisualization03ggplot2-facetGrid().png
> g + facet_grid(. ~ race)
# 變成每個族群分別再分性別，有8張
> g + facet_grid(sex ~ race)

# 安裝`GGally`套件，並載入
> check_then_install("GGally", "1.0.1")
> library(GGally)
# 4個欄位兩兩成對的散佈圖(read, write, math, science)
# 參照 RVisualization03ggplot2-ggpairs().png
> ggpairs(hsb, 7:10)


#################################################

# 已有個`population`資料，直接縮寫省的一直重複打
> p <- population

###### HW01 ######
> tb1 <- group_by(p, age) %>% summarise(much = sum(count))
> g <- ggplot(tb1, aes(age, much) + geom_line() + geom_point()
# 有線又有點
# tb1很重要，如果直接跑資料會超久=__=
              
# 解答
  g <-
    group_by(population, age) %>%
    summarise(count = sum(count)) %>%
    arrange(age) %>%
    ggplot(aes(x = age, y = count)) +
    geom_point() + geom_line()

            
              
              

###### HW02 ######

# `filter()`應該多加個縣市來過濾
# 和解答差別是在`group_by()`它是以村里及性別作為分類，得到的tibble為2 * 3
# 畫出來會有差別
> bg <- filter(p, site_id =="桃園市八德區", village == "大仁里") %>% 
        group_by(sex) %>%
        summarise(count = sum(count))
# `width = 1`填滿(變成直方圖形式)，加上哪一里
> ggplot(bg, aes(sex, count, fill=sex)) + geom_bar(stat="identity", width = 1 ) + labs(title="大仁里")
# https://stackoverflow.com/questions/32941670/width-and-gap-of-geom-bar-ggplot2

# 解答
 g <-
    filter(population, site_id == "新北市", village == "留侯里") %>%
    group_by(village, sex) %>%
    summarise(count = sum(count)) %>%
    ggplot(aes(x = village, y = count, fill = sex)) +
    geom_bar(position = "dodge", stat = "identity")

           
              
              
              
###### HW03 ######
> myPlace <- filter(p, site_id =="桃園市八德區", village == "大仁里") %>%
             ggplot(aes(age, count, color = sex)) + geom_line() + geom_point()
# 解答
 g <-
    filter(population, site_id == .hw_description[4], village == .hw_description[5]) %>%
    ggplot(aes(x = age, y = count, color = sex)) +
    geom_point() + geom_line()





###### HW04 ###### 
# 桃園與新北              
> ageRatio <- mutate(p, city = substring(site_id, 1, 3))  %>%
              filter(city == "桃園市" | city == "新北市") %>%
              group_by(city) %>%
              mutate(總人數 = sum(count), 比例 = count/ 總人數) %>%
              group_by(age, city) %>% 
              summarise(RATIO = sum(比例))
> ageRatio
# A tibble: 202 x 3
# Groups:   age [?]
     age   city       RATIO
   <int>  <chr>       <dbl>
 1     0 桃園市 0.010381426
 2     0 新北市 0.008324091
 3     1 桃園市 0.009857155
 4     1 新北市 0.009059488
 5     2 桃園市 0.008980995
 6     2 新北市 0.008096168
 7     3 桃園市 0.010846812
 8     3 新北市 0.009545807
 9     4 桃園市 0.009531385
10     4 新北市 0.008013310
# ... with 192 more rows                            
# 畫畫，把`color = city`去掉，會把桃園新北的點點都串成一條
> ggplot(ageRatio, aes(age, RATIO, color = city)) + geom_line() + geom_point()
              
# 解答              
 >  g <-
      mutate(population, city = substring(site_id, 1, 3)) %>%
      filter(city %in% c("桃園市", "新北市")) %>%
      group_by(city, age) %>%
      summarise(count = sum(count)) %>%
      group_by(city) %>%
      mutate(ratio = count / sum(count)) %>%
      ggplot(aes(x = age, y = ratio, color = city)) +
      geom_point() + geom_line()
              
#################################################
