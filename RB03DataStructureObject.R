# 每個變數都是物件
# 最小的單位就是向量
# 兩個重要屬性：`mode`, `length`
# mode()會回傳`logical`, `integer`, `numeric`, `complex`, `character`, `raw`

# `list()`，物件集結在一起的向量

# 建立以cars當資料的回歸模型
g <- lm(dist ~ speed, cars)

> mode(g)
[1] "list"
> length(g)
[1] 12

> attributes(g)
$names
 [1] "coefficients"  "residuals"     "effects"       "rank"          "fitted.values"
 [6] "assign"        "qr"            "df.residual"   "xlevels"       "call"         
[11] "terms"         "model"        

$class
[1] "lm"

# 就可以
> names(g)
 [1] "coefficients"  "residuals"     "effects"       "rank"          "fitted.values"
 [6] "assign"        "qr"            "df.residual"   "xlevels"       "call"         
[11] "terms"         "model"        

> attr(g, "class")
[1] "lm"
> class(g)
[1] "lm"



> g[1:2]
$coefficients
(Intercept)       speed 
 -17.579095    3.932409 

$residuals
         1          2          3          4          5          6          7          8 
  3.849460  11.849460  -5.947766  12.052234   2.119825  -7.812584  -3.744993   4.255007 
         9         10         11         12         13         14         15         16 
 12.255007  -8.677401   2.322599 -15.609810  -9.609810  -5.609810  -1.609810  -7.542219 
        17         18         19         20         21         22         23         24 
  0.457781   0.457781  12.457781 -11.474628  -1.474628  22.525372  42.525372 -21.407036 
        25         26         27         28         29         30         31         32 
-15.407036  12.592964 -13.339445  -5.339445 -17.271854  -9.271854   0.728146 -11.204263 
        33         34         35         36         37         38         39         40 
  2.795737  22.795737  30.795737 -21.136672 -11.136672  10.863328 -29.069080 -13.069080 
        41         42         43         44         45         46         47         48 
 -9.069080  -5.069080   2.930920  -2.933898 -18.866307  -6.798715  15.201285  16.201285 
        49         50 
 43.201285   4.268876 


> g[1]

$coefficients
(Intercept)       speed 
 -17.579095    3.932409 

> mode(g[1])
[1] "list"
> class(g[1])
[1] "list"


> g[[1]]
# 等同於
> g[["coefficients"]]

(Intercept)       speed 
 -17.579095    3.932409 

> mode(g[[1]])
[1] "numeric"
> class(g[[1]])
[1] "numeric"


> g[[1]][1]
(Intercept) 
  -17.57909 
> mode(g[[1]][1])
[1] "numeric"
> class(g[[1]][1])
[1] "numeric"

