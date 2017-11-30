# i變大，下一個會越來越小
> for(i in 1:99) x[i + 1] <- x[i] - 0.2 * x[i]

# 正斜線不用跳脫\
> paste0("data/", 1, ".csv")
[1] "data/1.csv"

# 直接讀取三個檔案變成`list`
# data/1.csv"、"data/2.csv"、"data/3.csv

> for(i in c(1, 2, 3)) retval[[i]] <- read.table(paste0("data/", i, ".csv"))
