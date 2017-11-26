# Factor是向量物件
# 因子：男女，家鄉
# 用來做分類的...

> blood_type
 [1] "B"  "A"  "A"  "O"  "AB" "O"  "A"  "AB" "O"  "AB" "O"  "AB" "A" 
[14] "A"  "A"  "AB" "A"  "AB" "AB" "A"  "AB" "A"  "AB" "B"  "A"  "O" 
[27] "A"  "A"  "AB" "AB"

> mode(blood_type)
[1] "character"

> class(blood_type)
[1] "character"

# `factor`起來，會多`levels`屬性
> blood_type_factor <- factor(blood_type)
> blood_type_factor
 [1] B  A  A  O  AB O  A  AB O  AB O  AB A  A  A  AB A  AB AB A  AB
[22] A  AB B  A  O  A  A  AB AB
Levels: A AB B O

> mode(blood_type_factor)
[1] "numeric"
> class(blood_type_factor)
[1] "factor"

> attributes(blood_type_factor)
$levels
[1] "A"  "AB" "B"  "O" 

$class
[1] "factor"

> levels(blood_type_factor)
[1] "A"  "AB" "B"  "O" 

> str(blood_type_factor)
 Factor w/ 4 levels "A","AB","B","O": 3 1 1 4 NA 4 1 2 4 2 ...


# 亂給沒有定義到的類別會變成`NA`
> blood_type_factor[5] <- "C"

# 預設是按照字母排列的levels，如何給順序呢？

# 沒順序還比條件，失敗！！
> blood_type_factor[1] > blood_type_factor[2]
[1] NA
# `ordered = TRUE`且`levels`為由小到大
> grades_factor <- factor(grades, ordered = TRUE, levels = c("C", "B", "A"))

> grades_factor
[1] A C B B A
Levels: C < B < A


# RStudio操作

# 有順序的物件
# 使用`str()`
# Ord.factor w/ 12

# 沒有的話
# Factor w/
