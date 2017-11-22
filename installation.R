# 先安裝好R以及Rstudio
# 開啟R



# install `swirl R package`
source("http://wush978.github.io/R/init-swirl.R")



# 如果出現以下訊息
# ERROR: dependency 'stringi' is not available for package 'swirl'

# `dependecies = TRUE` 會順便下載`stringi`
install.packages("swirl", dependencies = TRUE)



# 就可以開始引入swirl做你想做的事情
library(swirl)
swirl()

###### 若想要上別的課程呢？ ######
# 先 `library(swirl)`
install_course("R Programming")
install_course("Exploratory Data Analysis")
