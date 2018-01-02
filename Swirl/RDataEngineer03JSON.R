# vignette(package = "")
# fromJSON(x1, simplifyVector = FALSE), fromJSON(x1, simplifyVector = TRUE)
# rm(), all.equal(), isTRUE()

# 安裝、載入`jsonlite`套件
> check_then_install("jsonlite", "0.9.19")
> library(jsonlite)

# `vignette()`查詢能不能閱讀，跑出相關五篇文章
> vignette(package = "jsonlite")
# 使用說明畫面
> vignette("json-aaquickstart", "jsonlite")


> fromJSON(x1, simplifyVector = FALSE)
[[1]]
[1] "Amsterdam"

[[2]]
[1] "Rotterdam"

[[3]]
[1] "Utrecht"

[[4]]
[1] "Den Haag"

# `simplifyVector = TRUE`為預設值
> fromJSON(x1, simplifyVector = TRUE)
[1] "Amsterdam" "Rotterdam" "Utrecht"   "Den Haag" 










library(jsonlite)
youbike_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-03-JSON\\youbike.json"
youbike1 <- fromJSON(youbike_path)

# 請從youbike1中取出以下向量：

sna1 <- youbike1$result$results$sna
lat1 <- youbike1$result$results$lat
lng1 <- youbike1$result$results$lng
tot1 <- youbike1$result$results$tot
sbi1 <- youbike1$result$results$sbi


stopifnot(length(sna1) == 10)
stopifnot(length(lng1) == 10)
stopifnot(length(lat1) == 10)
stopifnot(length(tot1) == 10)
stopifnot(length(sbi1) == 10)
stopifnot(class(sna1) == "character")
stopifnot(class(lng1) == "character")
stopifnot(class(lat1) == "character")
stopifnot(class(tot1) == "character")
stopifnot(class(sbi1) == "character")

rm(youbike1) # 刪除youbike。

# 換另一種方式，`simplifyDataFrame = FALSE`
# 醜又占空間
youbike2 <- fromJSON(youbike_path, simplifyDataFrame = FALSE)


results <- youbike2$result$results

# 場站名稱(中文)。
sna2 <- { sapply(results, "[[", "sna") }
lng2 <- { sapply(results, "[[", "lng") }
lat2 <- { sapply(results, "[[", "lat") }
tot2 <- { sapply(results, "[[", "tot") }
sbi2 <- { sapply(results, "[[", "sbi") }

stopifnot(length(sna2) == 10)
stopifnot(length(lng2) == 10)
stopifnot(length(lat2) == 10)
stopifnot(length(tot2) == 10)
stopifnot(length(sbi2) == 10)
stopifnot(class(sna2) == "character")
stopifnot(class(lng2) == "character")
stopifnot(class(lat2) == "character")
stopifnot(class(tot2) == "character")
stopifnot(class(sbi2) == "character")

# 結果。
answer <- data.frame(stringsAsFactors = FALSE,
  sna = sna2,
  lat = as.numeric(lat2),
  lng = as.numeric(lng2),
  tot = as.integer(tot2),
  sbi = as.integer(sbi2)
)

stopifnot(nrow(answer) == 10)
stopifnot(isTRUE(all.equal(sum(answer$lat), 250.35549511)))
stopifnot(isTRUE(all.equal(sum(answer$lng), 1215.65644412)))
stopifnot(sum(answer$tot) == 702)
stopifnot(sum(answer$sbi) == 0)

