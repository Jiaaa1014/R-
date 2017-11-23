#################################################
############### lapply and sapply ###############
#################################################


# `head()`來顯示一組國旗資料的前6項
> head(flags)
# 後6項
> tail(flags)

# 194個國家，30個資料
> dim(flags)
[1] 194  30

# `attributes`裡面有`names`, `class`, `row_names`三個屬性
> attributes(flags)
$names
 [1] "name"       "landmass"   "zone"       "area"       "population" "language"   "religion"   "bars"      
 [9] "stripes"    "colours"    "red"        "green"      "blue"       "gold"       "white"      "black"     
[17] "orange"     "mainhue"    "circles"    "crosses"    "saltires"   "quarters"   "sunstars"   "crescent"  
[25] "triangle"   "icon"       "animate"    "text"       "topleft"    "botright"  

$class
[1] "data.frame"

$row.names
  [1]   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28
  ######   省略

# 可以個別叫出來
> names(flags)
> class(flags)
> row.names(flags)


# `lapply()`將`class()`用在`flags`這筆資料的column上，有些得到`factor`，有些是`integer`
> cls_list <-lapply(flags,class)
> cls_list
$name
[1] "factor"
$landmass
[1] "integer"
$zone
[1] "integer"
$language
[1] "integer"
######   省略
######   省略
######   省略
$topleft
[1] "factor"
$botright
[1] "factor"
######   總共30個

# `factor`為因子
# 可以以levels()來顯示有哪些因子
# nlevels()知道有幾個因子
# 參考：https://blog.gtwang.org/r/r-strings-and-factors/4/

# 想當然...
> class(cls_list)
[1] "list"
> class(cls_list["name"])
[1] "list"
> class(cls_list[["name"]])
[1] "character"

> as.character(cls_list)
 [1] "factor"  "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer"
[17] "integer" "factor"  "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "integer" "factor"  "factor" 

# simplified version
> cls_vect <- sapply(flags, class)
> cls_vect
      name   landmass       zone       area population   language   religion       bars    stripes    colours        red      green       blue       gold      white 
  "factor"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
     black     orange    mainhue    circles    crosses   saltires   quarters   sunstars   crescent   triangle       icon    animate       text    topleft   botright 
 "integer"  "integer"   "factor"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer"   "factor"   "factor" 
# 發現了嗎`sapply()`比`lapply()`還不占版面
> class(cls_vect)
[1] "character"

# 資料裡面column的11-17都是顏色，要怎麼知道有幾個國家用橘色呢？
> sum(flags$orange)
[1] 26

# 整個flags我只要colors資料
> flag_colors <- flags[,11:17]

# 每個color有哪些國家使用
> lapply(flag_colors, sum)
$red
[1] 153

$green
[1] 91

$blue
[1] 99

$gold
[1] 91

$white
[1] 146

$black
[1] 52

$orange
[1] 26

# 再一次，sapply總是好看多了
> sapply(flag_colors, sum)
   red  green   blue   gold  white  black orange 
   153     91     99     91    146     52     26 

# 要國旗的圖案資料
> flag_shapes <- flags[, 19:23]

# 找出`range()`
> shape_mat <- sapply(flag_shapes, range)
> shape_mat
     circles crosses saltires quarters sunstars
[1,]       0       0        0        0        0
[2,]       4       2        1        4       50
> class(shape_mat)
[1] "matrix"


# 同樣的東西只要一個只要1個
> unique(c(3,4,5,5,5,6,6))
[1] 3 4 5 6


# 從那30個columns名字找出值，重複的刪除
> unique_vals <- lapply(flags, unique)
> class(unique_vals)
[1] "list"
> sapply(unique_vals, length)
      name   landmass       zone       area population   language   religion       bars    stripes    colours        red      green       blue       gold      white 
       194          6          4        136         48         10          8          5         12          8          2          2          2          2          2 
     black     orange    mainhue    circles    crosses   saltires   quarters   sunstars   crescent   triangle       icon    animate       text    topleft   botright 
         2          2          8          4          3          2          3         14          2          2          2          2          2          7          8 

# 但這次`sapply()`以及`lapply()`顯示出來一樣又臭又長
> sapply(flags, unique)

# 取出30個又臭又長的名單中，各自的第2筆資料
> lapply(unique_vals, function(elem) elem[2])

