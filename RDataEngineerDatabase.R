# 資料庫，通常有指關聯式資料庫(Relational Database)
# 像是會計系統、購票系統就是常應用的例子

# 安裝RESlite套件，以及載入
> check_then_install("RSQLite", "1.0.0")
> library(RSQLite)


################ R ---- ?????????????? ---- 各種版本SQL資料庫


> db_path
[1] "C:\\Users\\Jiaaa\\AppData\\Local\\Temp\\RtmpMB82uE\\file18b07045941.db"
# 取得連接SQLite的方式
> drv <- dbDriver("SQLite")
> drv
<SQLiteDriver>

# 連線
> db <- dbConnect(drv, db_path)

# 新發現？
> class(db)
[1] "SQLiteConnection"
attr(,"package")
[1] "RSQLite"
> mode(db)
[1] "S4"

################ `dbWriteTable`從誰而來？
> ?dbWriteTable
# 左上角`dbReadTable {DBI}`可以知道是從DBI套件而來
# `overwrite`不是參數
# dbReadTable: database table -> data frame; 
# dbWriteTable: data frame -> database table.
#    /
#   /
> help.search("dbWriteTable")
# DBI::dbReadTable (copy功能)
# RSQLite::dbWriteTable,SQLiteConnection,character,character-method (write功能)
#   \
#    \
> help("dbWriteTable,SQLiteConnection,character,data.frame-method")
# 左上角`dbWriteTable,SQLiteConnection,character,data.frame-method {RSQLite}`


# 將已存在的變數`lvr_land`寫到名為lvr_land2的資料庫中
> dbWriteTable(db, "lvr_land2", lvr_land)
# 此函式的參數還包括
# `overwrite = TRUE`，撞名的被刪除，並寫入新的資料
# `append = TRUE`，寫入的資料接在撞名的表格下

# 測試`append`參數
> dbWriteTable(db, "lvr_land2", lvr_land, append = TRUE)
> dbReadTable(db, "lvr_land2")
# 結果總共寫了3次同樣的資料


# 查詢存在於資料庫的表格
> dbListTables(db)
[1] "CO2"       "TWII"      "iris"      "lvr_land2"
# 最後一個就是我們剛剛寫入的！


# 讀取`iris`表格另外命名為`iris2`
> iris2 <- dbReadTable(db, "iris")

# 兩者一樣嗎？
> all.equal(iris, iris2)
[1] "Component “Species”: 'current' is not a factor"
# iris2$Species轉換了！！
# 原先有是`factor`，被寫入表格再讀取後變成一般的`character`
> class(iris$Species)
[1] "factor"
> class(iris2$Species)
[1] "character"
# str(), attributes(), levels, nlevels和`factor`判斷有關的函式


# SQL的expression操作 + R
> dbGetQuery(db, "SELECT * FROM iris WHERE species = \"virginica\"")

> rs <- dbSendQuery(db, "SELECT * FROM iris")
> rs
<SQLiteResult>

> fetch(rs, 1)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
> fetch(rs, 1)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          4.7         3.2          1.3         0.2  setosa
# 第2次跑出的是第3筆資料！？


> dbClearResult(rs)
> fetch(rs)
錯誤: Expired SQLiteResult


# 危機處理
# 在使用資料庫這種具有連貫性的行為時，不是重下一次指令就可以解決的

# 斷線後重連
> dbDisconnect(db)
> db <- dbConnect(drv, db_path)
# 開啟Transaction
> dbBegin(db)
# 刪除其中一個存在的表格
> dbRemoveTable(db, "CO2")
> dbListTables(db)
[1] "TWII"      "iris"      "lvr_land2"


# 開始模擬斷線狀況，結果回復後CO2又回來了
> dbDisconnect(db)
> db <- dbConnect(drv, db_path)
> dbListTables(db)
[1] "CO2"       "TWII"      "iris"      "lvr_land2"
> dbBegin(db)
# 再刪除一次
> dbRemoveTable(db, "CO2")
> dbCommit(db)
> dbListTables(db)
[1] "TWII"      "iris"      "lvr_land2"

# 在這之後，即使重連線CO2表格不會回復了！
# 除了中斷連線，我們也可以主動使用`dbRollback(db)`指令，將資料庫的狀態復原至我們執行`dbBegin(db)`的時間點。

# `dbBegin()`，之後的變更要執行到`dbCommit()`才會「承認」
# 使用`dbRollback()`會自動回復到`dbBegin()`時刻










# 兩個檔案: file18b07045941.db(課程刪除CO2), file18b071fd3a57.db(預設)
db_path2 <- "C:\\Users\\Jiaaa\\AppData\\Local\\Temp\\RtmpMB82uE\\file18b07045941.db"

library(RSQLite)
drv <- dbDriver("SQLite")
db <- dbConnect(drv, db_path2)

# 如果重試時發生以下錯誤：
# Error in sqliteSendQuery(con, statement, bind.data) :
#  error in statement: database is locked
#Error in sqliteSendQuery(con, statement, bind.data) :
#  error in statement: database is locked
#Error in sqliteSendQuery(con, statement, bind.data) :
#  error in statement: database is locked
#Error in sqliteSendQuery(con, statement, bind.data) :
#  error in statement: database is locked
# 請執行：`gc()`。

# 請列出現在的資料庫中的表格清單。
tb_list <- {
  dbListTables(db)
}

# 請問同學，這段數據的日期範圍，是幾號到幾號呢？
twii_head <- {
  range(dbReadTable(db, "TWII")$date)[1]
}
twii_tail <- {
  range(dbReadTable(db, "TWII")$date)[2]
}
stopifnot(class(twii_head) == "character")
stopifnot(length(twii_head) == 1)
stopifnot(class(twii_tail) == "character")
stopifnot(length(twii_tail) == 1)

# 接著我們開啟一個Transaction。
dbBegin(db)

# R 內建的iris資料共有三種類別，一共150筆花的量測資料。
# 請同學將屬於setosa種類（Species的值為"setosa"）的資料，
# 寫入到database，並且取名為"setosa"。
gc()
{
  dbWriteTable(db, "setosa", iris[iris$Species == "setosa",], overwrite = TRUE)
  
}

# 讀取/寫入
{
  dbReadTable(db,"setosa")
}

# 最後，我們中斷連線。
dbDisconnect(db)

# 測試程式將會檢查這個資料庫內的資料。

