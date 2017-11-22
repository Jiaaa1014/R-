# form a Vector
> x <- 1:4
> x
[1] 1 2 3 4

> names(x) <- letters[1:4]
> x
a b c d 
1 2 3 4 

> c(1,2,3,4) + c(0,10,100)
[1]   1  12 103   4



#################################################
#################################################



# directory
# file

# 顯示出正在工作的地方  
> getwd()
[1] "C:/Users/Jiaaa/Documents"

# 列印出所有存在環境裡面的物件  
> ls()


# 列印出所有工作地點的檔案
# 也就是"C:/Users/Jiaaa/Documents"裡頭的files or directories
> dir()
> list.files()

# 不知道怎麼辦特無助的時候
> ?list.files # 但其實?list.files()也有用

# 可以參考function的參數
> args(list.files)
function (path = ".", pattern = NULL, all.files = FALSE, full.names = FALSE, 
    recursive = FALSE, ignore.case = FALSE, include.dirs = FALSE, 
    no.. = FALSE) 

# 建立資料夾
> dir.create("testdir")

# 進入資料夾
> setwd("testdir")
> getwd()
[1] "C:/Users/Jiaaa/Documents/testdir"
  
# 建立檔案
> file.create("mytest.R")

# 檔案在嗎
> file.exists("mytest.R")
  
  
# 檔案的資訊  
> file.info("mytest.R")
           size isdir mode               mtime               ctime               atime exe
  mytest.R    0 FALSE  666 2017-11-22 18:38:21 2017-11-22 18:38:01 2017-11-22 18:38:01  no


# 改名字
> file.rename("mytest.R","mytest2.R")
[1] TRUE

# 複製檔案
> file.copy("mytest2.R","mytest3.R")
[1] TRUE


# 當前工作地方建立一個有子資料夾的資料夾
> dir.create(file.path('testdir2', 'testdir3'), recursive = TRUE) 



#################################################
#################################################


  
# 使用backticks查特定運算子
> ?`:`

> 1:20
# 等於 
> seq(1, 20)
> seq(0,10, by=0.5)


# 參照別人的length，不是複製！！
> seq(along.with = another_seq)
# 等於
> seq_along(another_seq)
  
# rep() with times  
> rep(c(0, 1, 2), times = 10)
 [1] 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2
# rep() with each
> rep(c(0, 1, 2), each = 10)
 [1] 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2



#################################################
#################################################


# `my_char`是個存字串的vector
> paste(my_char, collapse = " ")
#  collapse同個位置的向量建立橋樑；sep不同組區隔

> paste(1:3 ,c("X", "Y", "Z"), sep="")
[1] "1X" "2Y" "3Z"

> paste(LETTERS, 1:4, sep ="-")
 [1] "A-1" "B-2" "C-3" "D-4" "E-1" "F-2" "G-3" "H-4" "I-1" "J-2" "K-3" "L-4" "M-1" "N-2"
[15] "O-3" "P-4" "Q-1" "R-2" "S-3" "T-4" "U-1" "V-2" "W-3" "X-4" "Y-1" "Z-2"
