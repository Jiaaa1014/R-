# XML及HTML都是由SGML而來的
# 相較於HTML，XML應用方式更自由

# 安裝xml2套件、載入
> check_then_install("xml2", "0.1.2")
> library(xml2)

> x1
[1] "<a><b>B</b><c>C1</c><c class='x'>C2</c></a>"


# 解析程式碼
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


> mode(doc1)
[1] "list"
Lengths (1, 2) differ (string compare on first 1)1 string mismatch

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







