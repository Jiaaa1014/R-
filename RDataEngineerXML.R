# XML及HTML都是由SGML而來的
# 相較於HTML，XML應用方式更自由

# 安裝xml2套件、載入
> check_then_install("xml2", "0.1.2")
> library(xml2)

> x1
[1] "<a><b>B</b><c>C1</c><c class='x'>C2</c></a>"


# 把那一串鬼東西以節點作為整理的把手
# 如果是網頁原始碼或是.html格式，則使用`read_html()`
doc1 <- read_xml(x1)

> doc1
{xml_document}
<a>
[1] <b>B</b>
[2] <c>C1</c>
[3] <c class="x">C2</c>


# xml2物件可分成三部分：xml_document > xml_nodeset > xml_node
# document代表整個文件、node是標籤
> class(doc1)
[1] "xml_document" "xml_node"    


# XPath路徑語言，和Routing很像
> xml_find_all(doc1, "/a/b")
{xml_nodeset (1)}
[1] <b>B</b>

# 連a都沒先講..
> xml_find_all(doc1, "/b")
{xml_nodeset (0)}

# 有兩個
> xml_find_all(doc1, "/a/c")
{xml_nodeset (2)}
[1] <c>C1</c>
[2] <c class="x">C2</c>
# 將路徑存到變數
> ns <- xml_find_all(doc1, "/a/c")

> class(ns)
[1] "xml_nodeset"
> mode(ns)
[1] "list"

> ns[1]
{xml_nodeset (1)}
[1] <c>C1</c>

# `[]`求你要的東西
> ns[[1]]
{xml_node}
<c>

> n1 <- ns[[1]]
> n2 <- ns[[2]]

# xml_text()求節點文字
> xml_text(n1)
[1] "C1"
> xml_text(ns[[2]])
[1] "C2"
> class(ns[2])
[1] "xml_nodeset"
> class(ns[[2]])
[1] "xml_node"


a <- xml_find_one(doc1, "/a")
# > xml_find_all(doc1, "/a")
# {xml_nodeset (1)}
# [1] <a>\n  <b>B</b>\n  <c>C1</c>\n  <c class="x">C2</c>\n</a>

> a
{xml_node}
<a>
[1] <b>B</b>
[2] <c>C1</c>
[3] <c class="x">C2</c>

> xml_text(a)
[1] "BC1C2"

# `xml_contents()`, `xml_children()`一樣
> xml_contents(a)
{xml_nodeset (3)}
[1] <b>B</b>
[2] <c>C1</c>
[3] <c class="x">C2</c>
> xml_children(a)
{xml_nodeset (3)}
[1] <b>B</b>
[2] <c>C1</c>
[3] <c class="x">C2</c>


# 看有無class
# 第1個c沒有，第2個有
# n1: ns[[1]], n2: ns[[2]]

> xml_attrs(n1)
named character(0)

> xml_attrs(n2)
class 
  "x" 


# 再一次使用`xml_find_all()`
# 要確認要找的標籤有class
> xml_find_all(doc1, "/a/c[@class]")
{xml_nodeset (1)}
 [1] <c class="x">C2</c>

# 還可以指定class為何
> xml_find_all(doc1, "/a/c[@class='g']")
{xml_nodeset (0)}





# 0080400004.html檔案
# 兩種表示方法，第二種不行
tender_path <- "C:\\Users\\Jiaaa\\Documents\\R\\win-library\\3.4\\swirl\\Courses\\DataScienceAndR\\02-RDataEngineer-02-XML\\0080400004.html"
# tender_path <- "C:/Users/Jiaaa/Documents/R/win-library/3.4/swirl/Courses/DataScienceAndR/02-RDataEngineer-02-XML/0080400004.html"

if (FALSE) {
  
  readLines(tender_path, n = 100)
  
  
  browseURL(tender_path, browser = "C:/Program Files/Mozilla Firefox/firefox.exe")

}

# 要加上
library(xml2)

# 首先請同學用read_html載入網頁內容
tender <- read_html(tender_path)

# 接下來，我們的目標是抓出所有的投標廠商名稱
# 透過瀏覽器的開發工具可以發現，裝載著廠商名稱的標籤是像這樣的：
# <tr>
#		<th class="T11b" bgcolor="#ffdd83" align="left" valign="middle" width="200">　廠商名稱</th>
#		<td class="newstop" bgcolor="#EFF1F1">
#			台灣翔登股份有限公司
#		</td>
#	</tr>
# 所以我們的策略是：
# 1. 先找出所有的tr標籤
# 2. 再找出底下有th的tr
# 3. th的內容必須要是"廠商名稱"


# "//"代表任何的tr
ths <- xml_find_all(tender, "//tr/th")

stopifnot(class(ths) == "xml_nodeset")
stopifnot(length(ths) == 116)

# 請取出每個ths中的th標籤的值，並且和 "　廠商名稱" 作比較
player_name_reference <- rawToChar(as.raw(c(227L, 128L, 128L, 229L, 187L, 160L, 229L, 149L, 134L, 229L,
                                            144L, 141L, 231L, 168L, 177L))) # "　廠商名稱"
Encoding(player_name_reference) <- "UTF-8"
ths_text <- xml_text(ths)
Encoding(ths_text) <- "UTF-8"
is_target <- ths_text == player_name_reference

#Boolean 值，FALSE + TRUE = 1
stopifnot(class(is_target) == "logical")
stopifnot(sum(is_target) == 4)
stopifnot(which(is_target)[1] == 36)

# 接著，請利用 `[`來從ths中選出那些值為 "　廠商名稱" 的xml_nodeset
ths2 <- ths[is_target]

stopifnot(class(ths2) == "xml_nodeset")
stopifnot(length(ths2) == 4)

# 因為我們的目標是th旁邊的td，所以要先透過`xml_parent`回到tr層級
trs <- xml_parent(ths2)

stopifnot(class(trs) == "xml_nodeset")
stopifnot(length(trs) == 4)

# 然後我們直接用xml_children取得這些tr的所有子標籤
trs_children <- xml_children(trs)

stopifnot(class(trs_children) == "xml_nodeset")
stopifnot(length(trs_children) == 8) # 一個tr有兩個子標籤

# 取出這些標籤的值
trs_children_text <- xml_text(trs_children)
Encoding(trs_children_text) <- "UTF-8"

stopifnot(class(trs_children_text) == "character")
stopifnot(length(trs_children_text) == 8)

# 只挑出那些值「不是」 "　廠商名稱"的元素
players <- trs_children_text[trs_children_text != player_name_reference]

# 其實這樣取出的廠商名稱還是很髒，有一大堆換行、tab字元等等
# 但是我們就先練習到這裡了




