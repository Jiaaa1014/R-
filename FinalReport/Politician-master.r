library(stringi)
library(dplyr)
library(magrittr)
library(ggplot2)

cb7 <- c("#005CAF", "#86C166", "#FBE251", "#D0104C", "#ffffff")
moneyGiven_path <- "C:\\Users\\Jiaaa\\Desktop\\Report\\politicalcontribution-master\\legislators\\2016\\A02_company_all_public.csv"
moneyGiven_info <- file.info(moneyGiven_path)
# moneyGiven_bin <- readBin(moneyGiven_path, what = "raw", n = moneyGiven_info$size)
# moneyGiven_txt <- stri_encode(moneyGiven_bin, "UTF-8", "BIG-5")
# moneyGiven <- read.table(textConnection(moneyGiven_txt), header = TRUE, sep = ",")
moneyGiven <- moneyGiven_path %>% readBin(what = 'raw', n = moneyGiven_info$size) %>% stri_encode("UTF-8", "BIG-5") %>% textConnection %>% read.table(header = TRUE, sep = ",")

## 選取重要的column來使用，且政黨只選擇有在線上的
moneyGiven %<>% select(候選人, 推薦政黨, 當選註記, 收入金額) %>%
                filter(推薦政黨 == '民主進步黨' | 推薦政黨 == '中國國民黨' | 推薦政黨 == '時代力量' | 推薦政黨 == '無黨團結聯盟' | 推薦政黨 == '無黨籍') 


# ------------------------------以上前置作業------------------------------


  ## 推薦政黨/候選人/isOnLine/sum/捐贈筆數
  eachPoliGet <-  mutate(moneyGiven, isOnLine = 當選註記 == '*',政黨 = 推薦政黨) %>% 
                  group_by(政黨, 候選人, isOnLine) %>% 
                  summarise(獻金總額 = sum(收入金額, na.rm = TRUE), 捐贈筆數 = n()) %>% 
                  arrange(政黨) 



  # 以政黨、勝落選為分類，獻金總額
  eachPartyWinOrLose <-  group_by(eachPoliGet, 政黨, isOnLine) %>% 
          summarise(獻金總額 = sum(獻金總額)) %>% arrange(政黨)
  # 以黨為分類，勝選族群所佔的獻金比例？
  MoneyWinsRatio <- group_by(eachPartyWinOrLose , 政黨) %>% 
           mutate(該黨獻金總額 = sum(獻金總額), 勝選所佔獻金比 = 獻金總額 / 該黨獻金總額) %>% 
           select(-c(獻金總額, 該黨獻金總額)) %>% filter(isOnLine)
  #  無黨團結聯盟CP值最高是因為只有一個高金素梅參選、當選
  ggplot(MoneyWinsRatio ,aes(政黨,勝選所佔獻金比, fill=政黨)) + 
    geom_bar(stat="identity") + ggtitle("獻金當選率") + 
    scale_fill_manual(values=cb7)
 
  # 以黨為分類，勝選族群所佔的人數比例？
  GuysWinsRatio <- eachPoliGet %>%
           group_by(政黨, isOnLine) %>% 
           mutate(人次 = n()) %>% group_by(政黨) %>% 
           mutate(總人次 = n(), 勝選所佔人數比 = (人次 /總人次)) %>% 
           distinct(isOnLine, 政黨, 勝選所佔人數比) %>% filter(isOnLine == TRUE)
  # 合併
  Ratio_All <-left_join(MoneyWinsRatio, GuysWinsRatio)
  # 22
  ggplot(Ratio_All) + theme_grey() + labs(title = 'bar代表勝選人數所佔人數比例，線代表勝選所佔獻金比', y = "", x = "") +
    geom_bar(aes(政黨, 勝選所佔人數比, fill=政黨), stat = "identity", alpha = 0.8) +
    geom_line(aes(政黨, 勝選所佔獻金比), stat = "identity", group = 1) + 
    geom_point(aes(政黨,勝選所佔獻金比), stat = "identity", group = 1) + scale_fill_manual(values=cb7) +
    theme(axis.text.x = element_blank(), axis.ticks = element_blank())
 
  # 每政黨獻金總額，參考意義不大
  # 00
  ggplot(eachPoliGet, aes(政黨, 獻金總額, fill = 政黨)) + geom_histogram(stat = "identity") + scale_fill_manual(values = cb7)
 
 
 
 
  # 以有無勝選為族群，獻金總額及比例
  winOrLoseGet <- group_by(eachPoliGet, isOnLine) %>% 
                  summarise(獻金總額 = sum(獻金總額)) %>% 
                  mutate(該結果比例 = 獻金總額 / sum(獻金總額))
  # 07
  ggplot(winOrLoseGet,aes("", 該結果比例, fill = isOnLine)) + 
    geom_bar(stat = "identity", alpha = 0.8) + 
    coord_polar(theta = "y") + scale_fill_manual(values = c("#787878","#CB4042")) + 
    labs(title ="勝選一方的獻金大約佔了七成", x = "", y = "")
 
  # 以黨為分類，幾筆獻金、獻金總額
  eachPartyGet <- group_by(eachPoliGet, 政黨) %>% 
                mutate(該黨獻金總額 = sum(獻金總額), 該黨捐贈筆數 = sum(捐贈筆數)) %>% 
                distinct(政黨,該黨獻金總額,該黨捐贈筆數)
  
  tmp <- mutate(eachPoliGet, 平均=獻金總額/捐贈筆數)
  
  # 以黨為分類，獻金的density
  eachPoliGet1<- group_by(eachPoliGet, 候選人) %>% summarise(獻金總額萬元 = 獻金總額/10000)
  # 01
  ggplot(eachPoliGet1, aes(獻金總額萬元)) + theme_gray()+ theme(aspect.ratio = 1 / 2) +
    geom_density() + 
    geom_vline(xintercept = mean(eachPoliGet1$獻金總額萬元)) 
   
  density(eachPoliGet1$獻金總額萬元)
  
 
  
  # 全體來看，所有候選人的獻金總額
  # 32
  ggplot(eachPoliGet, aes(候選人, 獻金總額, color = 政黨)) + theme_dark() +
    geom_point(size = 2) + theme(legend.box.margin = margin(0, 0, 170, -100), axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values=cb7) + geom_hline(yintercept = mean(eachPoliGet$獻金總額))
  #31
  ggplot(eachPoliGet, aes(候選人, 獻金總額, color = isOnLine)) + theme_grey() +
    geom_point(size = 2) + theme(legend.box.margin = margin(0, 0, 230, -100), axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values = c("#787878","#CB4042")) + geom_hline(yintercept = mean(eachPoliGet$獻金總額))
  
  # 各黨看候選人的獻金總額，紅色代表online
  # 33
  ggplot(eachPoliGet, aes(候選人, 獻金總額, color = isOnLine)) + 
    geom_point(size = 2) + theme(legend.box.margin = margin(0, 0, 70, -80), legend.justification = c("right", "bottom"), axis.text = element_blank(), 
                         axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values = c("#787878","#CB4042")) + facet_wrap( ~ 政黨) + labs(subtitle = "紅色為選上立委")
  
  
  
  # 獻金與捐贈筆數的關係
  # 數量少，總額多的是柯建銘、吳秉叡，吳育昇及丁守中重疊,上半部
  # 相反地，王定宇及陳亭妃的捐贈數量較多
  # 總體
  # 40
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_grey() +
    geom_point() + scale_color_manual(values = cb7) + geom_smooth(se = FALSE, method = "lm") + 
    geom_abline(intercept = 1746139, slope = 109232)
  
  # 這張圖顯示了一個重點，先前報告提到企業會因扣除額限制的關係給予捐贈，所以既然都要做做面子，
  # 一次捐100萬，或是20萬捐給5個人示好效益會比較高，且企業除了大筆捐斯的私交關係，
  # 有些傾向於測風向做事的捐贈額度低、數量多。
  # 民進黨的捐贈數量前二十名佔了19位
  # 斜率 ...
  
    #| Coefficient  | B0       |   B1   |
    #| :----------: | :------- | :----: |
    #|  中國國民黨  | 1012165  | 173414 |
    #|  民主進步黨  | 2204964  | 92647  |
    #|   時代力量   | 933278   | 71176  |
    #| 無黨團結聯盟 | 1500000  |   NA   |
    #|    無黨籍    | -18373   | 152752 |
  
  
  
  
  # 各黨
  # 41
  ggplot(eachPoliGet, aes(捐贈筆數, 獻金總額, label = 候選人, color = 政黨)) + theme_dark() +
    geom_point(size = 1.3) + scale_color_manual(values = cb7) + 
    geom_smooth(se = FALSE, method = "lm") + facet_wrap(~ 政黨, scales = "free") + 
    theme(panel.grid = element_blank())

  
  
  # two dummy variables
  twoParties <- filter(eachPoliGet, 政黨 == "中國國民黨" | 政黨== "民主進步黨") %>%
    mutate(isBlue = as.numeric(政黨 == "中國國民黨"),isOnLine = ifelse(isOnLine, 1,0))
  

  lm(獻金總額 ~ isBlue, twoParties)
  # Coefficients:
  # (Intercept)       isBlue  
  #     7538993     -2269870  

  lm(獻金總額 ~ 捐贈筆數 + isBlue, twoParties)
  # Coefficients:
  # (Intercept)     捐贈筆數       isBlue  
  #      932901       114741      1519558  
  
  lm(獻金總額 ~ 捐贈筆數, twoParties)
  # Coefficients:
  # (Intercept)     捐贈筆數  
  #     2163102       104576  
  
  lm(捐贈筆數 ~ isBlue, twoParties)
  # Coefficients:
  #   (Intercept)       isBlue  
  #         57.57       -33.03  
  
  lm(獻金總額 ~ 捐贈筆數 + isOnLine + isBlue, twoParties)
  # Coefficients:
  # (Intercept)     捐贈筆數     isOnLine       isBlue  
  #     -475102       109559      2081777      2370359  
  
  lm(捐贈筆數 ~ isBlue + isOnLine, twoParties)
  # Coefficients:
  # (Intercept)       isBlue     isOnLine  
  #       47.19       -26.81        12.66  
  
  lm(獻金總額 ~ isBlue + isOnLine, twoParties)
  # Coefficients:
  # (Intercept)       isBlue     isOnLine  
  #     4695485      -566882      3469080  
  
  lm(isOnLine ~ isBlue , twoParties)
  #  Coefficients:
  #  (Intercept)       isBlue  
  #       0.8197      -0.4909  
  

  