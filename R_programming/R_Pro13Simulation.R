# 1-6選4個，可以重複，每次指令出現的結果不同
> sample(1:6, 4, replace = TRUE)
[1] 6 1 3 4

# `replaceent`沒寫，預設FALSE
> sample(1:20, 10)
 [1]  8  9  1  7 11 13  5  3  6  2


# 擲不公平硬幣，0.3反面(0)，0.7正面(1)，100次
> flips
  [1] 1 1 1 1 1 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 0
 [41] 1 1 1 1 0 1 0 1 0 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 0 0 1 1 0 0 1 1 1 0 1 0 0
 [81] 0 1 1 1 1 0 1 0 1 0 0 1 0 0 1 0 1 1 0 1
# 69個正面
> sum(flips)
[1] 69

# 二項分布，值為1的機率為70%，做100次或有100組樣本
> rbinom(1, size = 100, prob = 0.7)
[1] 60

# 隨機10個標準常態分布
# mean = 0, sd = 1
rnorm

# 卜瓦松分布Poisson Distribution
# lambda相當於mean，且 > 0
> rpois(5, lambda = 10)
[1] 11  7 13  9 15


# 做100次，會有100組的結果
> my_pois <- replicate(100, rpois(5,10))
#                             [,99] [,100]
#     [1,]                      4     13
#     [2,]                     12     14
#     [3,]       1...到100      9      5
#     [4,]                      8     14
#     [5,]                      9      7

# 每一組的mean，當然有一百個
> colMeans(my_pois)

> class(colMeans(my_pois))
[1] "numeric"


# 畫圖畫圖：直方圖
> hist(cm)


# 補充：

# 在R_Pro05-08.R有提過[r/d/p/q]norm()
# 搭配分布
# r: random
# d: density
# p: probability
# q: quantile

# d可以想成是剩下的雙尾佔了多少%
# p就當作這個地點累積了多少%

# 參數意義
# n: 觀測數目
# x: 標準化後的值
# p: 機



# Normal Distribution: 
 # rnorm(), 
 # dnorm(), 
 # pnorm(), 
 # qnorm()

# Binomial Distribution: 
 # rbinom(n,size,prob), 
 # dbinom(x,size,prob), 
 # pbinom(x,size,prob), 
 # qbinom(p,size,prob)

# Poisson Distribution(偏左的山): 
 # rpois(n,lambda), 
 # dpois(x,lambda), 
 # ppois(x,lambda), 
 # qpois(p,lambda)

# Gamma Distribution(low, highest, lower): 
 # rgamma(n,shape,scale), 
 # dgamma(x,shape,scale), 
 # pgamma(x,shape,scale), 
 # qgamma(p,shape,scale)

# If a Chi-Squared distribution has p degrees of freedom, then this is identical to a Gamma(p/2,2) distribution.

# Chi Square: 
 # rchisq(n, df), 
 # dchisq(x, df), 
 # pchisq(x ,df), 
 # qchisq(p, df)


