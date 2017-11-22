
#設定目錄，請設定為自己電腦可使用的目錄
setwd("C:/Users/Jiaaa/Desktop/105_IE")

# 所需要用到的 package
pkg <- c("tidyr", "dplyr", "ggplot2", "knitr", "rmarkdown","tseries","lmtest","car","nlme","AER")

# Check if packages are not installed and assign the
# names of the uninstalled packages to the variable new.pkg
new.pkg <- pkg[!(pkg %in% installed.packages())]

# If there are any packages in the list that aren't installed,
# install them
if (length(new.pkg)) {
  install.packages(new.pkg, repos = "http://cran.rstudio.com")
}


#把它們叫出來
library(rmarkdown)
library(knitr)
library(dplyr)
library(tidyr)
library(AER)
library(tseries)
library(car)
library(nlme)
library(tseries)
library(lmtest)
library(ggplot2)

#################################################
################讀取資料#########################
#################################################

#讀取資料
data <- read.csv("rawdata.csv")

View(data)


#################################################
################進行資料修正#######################
#################################################


#改變資料形式
data$time <- as.Date(data$time)
#確認 data 的形式
str(data)


#################################################
################初步了解資料#####################
#################################################

#形容securies.growth的分配型態
#製作所有的圖形來觀察是否具有時間趨勢
#securies.growth
ggplot(data, aes(time,securies.growth))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#unemployment
ggplot(data, aes(x=time,y=unemployment))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#inflation
ggplot(data, aes(x=time,y=inflation))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#fedrate
ggplot(data, aes(x=time,y=fedrate))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")


#################################################
################開始進行專案分析##################
#################################################

#進行 adf test 確定是否為定態

adf.test(data$securies.growth)
adf.test(data$unemployment)
adf.test(data$inflation)
adf.test(data$fedrate)

#對非定態的函數進行差分
unemployment.1 <- diff(data$unemployment)
adf.test(unemployment.1)
inflation.1 <- data$inflation
adf.test(inflation.1)
fedrate.1 <- diff(data$fedrate)
adf.test(fedrate.1)
summary(fedrate.1)
sd(fedrate.1)
sd(data$securies.growth)


#因為差分以後會缺少資料，所以要進行 data 的修改，改為 data1
data1 <- data[-1,]
#把 data1 資料中的原始數據用差分後的數據取代
data1$unemployment <- unemployment.1
data1$fedrate <- fedrate.1
#確認資料形式
View(data1)
#對差分的數據進行繪圖
#unemployment.1
ggplot(data1, aes(x=time,y=unemployment.1))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#fedrate.1
ggplot(data1, aes(x=time,y=fedrate.1))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#差分完以後變成定態，藉由 lmtest 確定是否有序列相關

#進行 Breusch-Godfrey LM 檢定
bgtest(formula=securies.growth ~ unemployment+inflation+fedrate, order = 1, order.by = NULL, type = c("Chisq", "F"),
       data = data1, fill = 0)

#################################################
################可以忽略的部分###################
#################################################

#先進行OLS
sec.ols <-lm(securies.growth ~ unemployment+inflation+fedrate,data=data1)
summary(sec.ols)

#畫出 OLS 的殘差模型
ggplot(data1, aes(x=time,y=residuals(sec.ols)))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
#################################################
#################################################
#################################################

#使用 Durbin-Waston 檢定

durbinWatsonTest(sec.ols, max.lag=8)

#顯示有 autocorrelation
acf(residuals(sec.ols))
acf(residuals(sec.ols), type="partial")


#################################################
################模型建置#########################
#################################################

#進行 gls 回歸模型

sec.gls <- gls(securies.growth ~ unemployment+inflation+fedrate,data=data1, correlation=corARMA(p=4), method="ML")
summary(sec.gls)

#進行 lmtest 分析
datalm<- data1 
View(datalm)
residdata0<-as.matrix(resid(sec.ols))
View(residdata0)
#第ㄧ個殘差
residdata1 <-as.matrix(residdata0[-c(1,2,3,4),])
#第二個殘差
residdata2<-as.matrix(residdata0[-c(1,2,3,644),])
#第三個殘差
residdata3<-as.matrix(residdata0[-c(1,2,643,644),])
#第四個殘差
residdata4<-as.matrix(residdata0[-c(1,642,643,644),])
#處理掉最後四項的data1
dataforlmtest<-datalm[-c(1,2,3,4),]
#將所以的資料統整在一起
dataforlmtest <-cbind(dataforlmtest,residdata1,residdata2,residdata3,residdata4)
View(dataforlmtest)
?bgtest
AR4<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1+residdata2+residdata3+residdata4, order = 4, order.by = NULL, type = "Chisq",
       data = dataforlmtest, fill = 4)
print(AR4)
AR3<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1+residdata2+residdata3, order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest, fill = 0)
AR2<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1+residdata2, order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest, fill = 0)
AR1<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1, order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest, fill = 0)
class(bgtest)

print(AR3)
print(AR2)
print(AR1)
#進行更多的殘差分析
#第ㄧ個殘差
residdata1. <-as.matrix(residdata0.[-c(1,2,3,4,5,6,7),])
#第二個殘差
residdata2.<-as.matrix(residdata0.[-c(1,2,3,4,5,6,644),])
#第三個殘差
residdata3.<-as.matrix(residdata0.[-c(1,2,3,4,5,643,644),])
#第四個殘差
residdata4.<-as.matrix(residdata0.[-c(1,2,3,4,642,643,644),])
#第五個殘差
residdata5.<-as.matrix(residdata0.[-c(1,2,3,641,642,643,644),])
#第六個殘差
residdata6.<-as.matrix(residdata0.[-c(1,2,640,641,642,643,644),])
#第七個殘差
residdata7.<-as.matrix(residdata0.[-c(1,639,640,641,642,643,644),])
#處理掉最後四項的data1
dataforlmtest.<-datalm[-c(1,2,3,4,5,6,7),]
dataforlmtest.<- cbind(dataforlmtest.,residdata1.,residdata2.,residdata3.,residdata4.,residdata5.,residdata6.,residdata7.)
View(dataforlmtest.)
ols7 <- lm(securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5.+residdata6.+residdata7.,data = dataforlmtest.)
print(ols7)
ar7 <-bgtest(ols7, order = 1, order.by = NULL, type = c("Chisq", "F"),
             data = dataforlmtest., fill = 0)
ar7 <-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5.+residdata6.+residdata7., order = 1, order.by = NULL, type = c("Chisq", "F"),
       data = dataforlmtest., fill = 0)
ar5<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5., order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest., fill = 0)
ar6<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5.+residdata6., order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest., fill = 0)

ar4<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4., order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest., fill = 0)

ar3<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate, order = 2, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest., fill = 0)
ar2<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2., order = 1, order.by = NULL, type = c("Chisq", "F"),
            data = dataforlmtest., fill = 0)


bgtest(formula=securies.growth ~ unemployment+inflation+fedrate, order = 7, order.by = NULL, type = c("Chisq", "F"),
       data = dataforlmtest., fill = 0)
print(ar7)
print(ar6)
print(ar5)
print(AR4)
print(ar3)
print(ar2)

#進行Breusch-Godfrey LM 檢定
AR4 <- bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1+residdata2+residdata3+residdata4, order = 1, order.by = NULL, type = c("Chisq", "F"),
       data = dataforlmtest, fill = 0)
AR5<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5., order = 1, order.by = NULL, type = c("Chisq", "F"),
       data = dataforlmtest., fill = 0)
AR6<-bgtest(formula=securies.growth ~ unemployment+inflation+fedrate+residdata1.+residdata2.+residdata3.+residdata4.+residdata5.+residdata6., order = 1, order.by = NULL, type = c("Chisq", "F"),
       data = dataforlmtest., fill = 0)
AR7<-

print(AR4)
print(AR5)
print(AR6)
print(AR7)


#########################################
###############結果分析##################
#########################################

#對 GLS 結果進行分析
bgtest(resid(sec.gls),  type = c("Chisq", "F"))
sec.gls.7 <- update(sec.gls, correlation=corARMA(p=7))
sec.gls.5 <- update(sec.gls, correlation=corARMA(p=5))
sec.gls.6 <- update(sec.gls, correlation=corARMA(p=6))
sec.gls.3 <- update(sec.gls, correlation=corARMA(p=3))
sec.gls.2 <- update(sec.gls, correlation=corARMA(p=2))
anova(sec.gls, sec.gls.5)
anova(sec.gls, sec.gls.3)
anova(sec.gls, sec.gls.7)
anova(sec.gls, sec.gls.4)
??anova
#標準化
View(data)




###################################################
################過去嘗試撰寫的 coding##############
###################################################
?gls
resid(sec.gls)
plot(resid(sec.gls))
coef(sec.gls)
fitted(sec.gls)
glsObject(sec.gls)
durbinWatsonTest(resid(sec.gls))
#畫圖
ggplot(data1, aes(x=time,y=residuals(sec.gls)))+
  geom_line(col="#336666")+
  stat_smooth(method="lm",se=T,col="blue")
acf(residuals(sec.gls))
acf(residuals(sec.gls),type="partial")
dwtest(residuals(sec.gls), alternative="two.sided")
sec.gls<-as.data.frame(sec.gls)
class(sec.gls)


ts.plot(sec.gls,main="Time series data")




data("SportsCards")
summary(SportsCards)
plot(trade ~ permonth, data = SportsCards,
     ylevels = 2:1, breaks = c(0, 5, 10, 20, 30, 70))
plot(trade ~ years, data = SportsCards,
     ylevels = 2:1, breaks = c(0, 5, 10, 20, 60))






