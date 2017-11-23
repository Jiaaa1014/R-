# 載入資料
> data(cars)

> str(cars)
'data.frame':   50 obs. of  2 variables:
 $ speed: num  4 4 7 7 8 9 10 10 10 11 ...
 $ dist : num  2 10 4 22 16 10 18 26 34 17 ...

# 前6筆
> head(cars)
  speed dist
1     4    2
2     4   10
3     7    4
4     7   22
5     8   16
6     9   10

# 會出現一個速度與煞車距離成正比指數關係的圖
# `plot`是scatterplot的縮寫
> plot(cars)
# 等於
plot(dist ~ speed, cars)


# 圖一樣，xy軸表示不同
> plot(x = cars$speed, y = cars$dist)
# 就xy相反過來
> plot(x = cars$dist, y = cars$speed)

# 還可以自己命名xy軸
> plot(x = cars$speed, y = cars$dist, xlab = "Speed")
# 兩個都改名
> plot(x = cars$speed, y = cars$dist, xlab = "Speed", ylab = "Stopping Distance")

# 標題
> plot(cars, main = "My Plot")
# 副標題，在x軸名字下面
> plot(cars, sub = "My Plot Subtitle")


# 有些參數沒有在`?plot`裡面
> ?par

# ?plot是`xaxs`，正確要輸入`xlim`
# x軸限定在10-15
> plot(cars, xlim = c(10,15))

# 將點點改成三角形
> plot(cars, pch = 2)

# 載入mtcars
> data(mtcars)

# `play()`來暫停課程且不會被影響到內容：娛樂模式
# 然後暫時醒醒腦或是有些卡住的指令可以輸入看一看
# 回來就nxt()

# ?boxplot
# `mpg`在y軸，`cy1`在x軸
> boxplot(formula = mpg ~ cyl, data = mtcars)

# 前面提過的`hist()`是直方圖，一維的
> hist(mtcars$mpg)



# 有些更厲害的圖透過package
# 像是lattice(), ggplot2()
> library(lattice)
> library(ggplot2)
# 參考
# https://learnr.wordpress.com/2009/06/28/ggplot2-version-of-figures-in-lattice-multivariate-data-visualization-with-r-part-1/
# http://www.londonr.org/download/?id=69
