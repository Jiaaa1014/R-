# 前一節中，取出30種資料的值，不重複，又臭又長的lists
> sapply(flags, unique)

# 原本預期每個小list都是長度1，但第一個就不是惹
> vapply(flags, unique, numeric(1))
Error in vapply(flags, unique, numeric(1)) : 值的長度必須是 1，
但是 FUN(X[[1]]) 的結果長度是 194

# 也是上一節，判斷30種資料的`class()`
> sapply(flags, class)
      name   landmass       zone       area population   language   religion 
  "factor"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
      bars    stripes    colours        red      green       blue       gold 
 "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
     white      black     orange    mainhue    circles    crosses   saltires 
 "integer"  "integer"  "integer"   "factor"  "integer"  "integer"  "integer" 
  quarters   sunstars   crescent   triangle       icon    animate       text 
 "integer"  "integer"  "integer"  "integer"  "integer"  "integer"  "integer" 
   topleft   botright 
  "factor"   "factor" 

# 得到和`vapply()`一樣的結果
# 在抓取資料的方式上習慣`sapply()`
# 而`vapply()`再大量資料時，感受比較快
> vapply(flags, class, character(1))
