#################################################
################### Functions ###################
#################################################


> Sys.Date()
[1] "2017-11-23"

> boring_function
function(x) {
  x
}

<bytecode: 0x0000000004b8dfa0>

# 設default
# 且`function`不須return
remainder <- function(num, divisor = 2) {
  num %% divisor
  # Write your code here!
  # Remember: the last expression evaluated will be returned! 
}

# 還可以不用照順序輸入
> remainder(divisor = 11, num = 5)
[1] 5

> args(remainder)
function (num, divisor = 2) 
NULL


# 將原本存在的func拿來用
#    1. evaluate(sum, c(2, 4, 6)) should evaluate to 12
#    2. evaluate(median, c(7, 40, 9)) should evaluate to 9
#    3. evaluate(floor, 11.1) should evaluate to 11
evaluate <- function(func, dat){
  func(dat)
}

# 只要第1個
> evaluate(function(x){x[1]},c(8,4,0))
[1] 8
# 我要最後一個
> evaluate(function(x){x[length(x)]},c(8,4,0))
[1] 0

# 自己寫`paste`改良版本
# For example the expression `telegram("Good", "morning")` should evaluate to:
# "START Good morning STOP"
telegram <- function(...){
  paste("START", ..., "STOP")
}


# 恩，這好怪，別忽略double quotes
"%p%" <- function(...){ # Remember to add arguments!
  paste(...)
}
> "I" %p% "love" %p% "R!"
[1] "I love R!"


