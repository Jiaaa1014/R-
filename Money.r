library(stringi)
library(dplyr)
library(magrittr)
library(ggplot2)


cb7 <- c("#005CAF", "#86C166", "#FBE251", "#D0104C", "#ffffff", "#0072B2" )
moneyGiven_path <- "C:\\Users\\Jiaaa\\Desktop\\Report\\politicalcontribution-master\\legislators\\2016\\A02_company_all_public.csv"
moneyGiven_info <- file.info(moneyGiven_path)
# moneyGiven_bin <- readBin(moneyGiven_path, what = "raw", n = moneyGiven_info$size)
# moneyGiven_txt <- stri_encode(moneyGiven_bin, "UTF-8", "BIG-5")
# moneyGiven <- read.table(textConnection(moneyGiven_txt), header = TRUE, sep = ",")
moneyGiven <- moneyGiven_path %>% readBin(what = 'raw', n = moneyGiven_info$size) %>% stri_encode("UTF-8","BIG-5") %>% textConnection %>% read.table(header=TRUE, sep=",")

## 選取重要的column來使用，且政黨只選擇有在線上的
moneyGiven %<>% select(-序號,-統一編號,-交易日期, -捐贈者.支出對象, -支出金額, -地址, -P, -收支科目) %>%
                filter(推薦政黨 == '民主進步黨'|推薦政黨 == '中國國民黨'|推薦政黨 == '時代力量'|推薦政黨 == '無黨團結聯盟'|推薦政黨 == '無黨籍') 

## 推薦政黨/候選人/isOnLine/sum/捐贈筆數
eachPoliGet <-  mutate(moneyGiven, isOnLine = 當選註記 =='*') %>% 
                group_by(推薦政黨, 候選人, isOnLine) %>% 
                summarise(sum = sum(收入金額, na.rm = TRUE), 捐贈筆數 = n()) %>% 
                arrange(推薦政黨) 



 # 以政黨、勝落選為分類，獻金總額
 dat1 <-  group_by(eachPoliGet, 推薦政黨, isOnLine) %>% 
          summarise(sum = sum(sum)) %>% arrange(desc(sum))
 # 以黨為分類，勝選族群所佔的獻金比例？
 dat1CP <- group_by(dat1, 推薦政黨) %>% 
           mutate(該黨獻金總額 = sum(sum), 所佔獻金比 = sum / 該黨獻金總額) %>% 
           select(-c(sum, 該黨獻金總額)) %>% filter(isOnLine)
 #  無黨團結聯盟CP值最高是因為只有一個高金素梅參選、當選
 ggplot(dat1CP,aes(推薦政黨,ratio, fill=推薦政黨)) + geom_bar(stat="identity") + ggtitle("獻金當選率")  + scale_fill_manual(values=cb7)

 
 
 
 
 # 以黨為分類，勝選族群所佔的人數比例？
 dat2CP <- eachPoliGet %>% filter(推薦政黨!='') %>% 
           group_by(推薦政黨, isOnLine) %>% 
           mutate(人次 =n()) %>% group_by(推薦政黨) %>% 
           mutate(總人次 = n(),比例 =(人次 /總人次)) %>% 
           distinct(isOnLine,推薦政黨,比例) %>% filter(isOnLine == TRUE)


 # 合併
 dat3 <-left_join(dat1CP,dat2CP)
 names(dat3) <- c("政黨", "onLine", "獻金當選率", "人數當選率")
 
 
 
 
 # 以勝選為族群，獻金總額及比例

 winOrLoseGet <-  group_by(eachPoliGet, isOnLine) %>% 
                  summarise(sum = sum(sum)) %>% 
                  mutate(ratio = sum/sum(sum))


 
 # 以黨為分類，幾筆獻金、獻金總額
  countByParty <- group_by(eachPoliGet, 推薦政黨) %>% 
                  mutate(捐贈總額 = sum(sum),捐贈筆數 = sum(捐贈筆數)) %>% 
                  distinct(推薦政黨,捐贈筆數,捐贈總額)
  
  
  
  # 以黨為分類，獻金的density
  ggplot(eachPoliGet, aes(推薦政黨,color=推薦政黨)) + geom_density()
   ggplot(filter(eachPoliGet,推薦政黨=="中國國民黨"),aes(推薦政黨)) + geom_density()
  

 
  
  # 全體來看，x,y = 候選人，獻金總額
  ggplot(eachPoliGet, aes(候選人, sum, color= 推薦政黨,fill=isOnLine)) + theme_dark()+
    geom_point() + theme(axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values=cb7) +  facet_wrap(~推薦政黨) 
  
  
  # 各黨 
  ggplot(eachPoliGet, aes(候選人, sum, color=isOnLine)) + theme_dark() +
    geom_point() + theme(legend.box.margin = margin(6, 6, 6, 6),axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank()) +
    scale_color_manual(values=c("green","red")) + facet_wrap(~推薦政黨) + labs(title="紅色為選上立委")
  
  
  # 每政黨獻金總額 
  
  ggplot(eachPoliGet, aes(推薦政黨, sum, fill=推薦政黨)) + 
    geom_histogram(stat="identity") + 
    scale_fill_manual(values=cb7)
  
  
  
  
  # 獻金與捐贈筆數的關係
  # 數量少，總額多的是柯建銘、吳秉叡，吳育昇及丁守中重疊
  # 總體
  ggplot(eachPoliGet, aes(sum,捐贈筆數,label=候選人, color=推薦政黨)) + theme_dark() +
    geom_point() + scale_color_manual(values=cb7) +geom_smooth(se = FALSE,method = "lm") + geom_text()
 
   # 各黨
  ggplot(eachPoliGet, aes(sum,捐贈筆數,label=候選人, color=推薦政黨)) + theme_dark() +
    geom_point() + scale_color_manual(values=cb7) +
    geom_smooth(se = FALSE, method = "lm")+
    facet_wrap(~推薦政黨)
  
