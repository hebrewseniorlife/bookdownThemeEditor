bd_line_height <- function(x = 1.5) {
  glue(".book .book-body .page-wrapper .page-inner section.normal",
       " {line-height: [x]em;}",
       .open = "[", .close = "]")
}

bd_toc_width <- function(x) {
  body_width <- 800 + (300 - x)
  glue(
    ".book .book-summary{left:-[x]px;width:[x]px;}",
    ".book .book-body .page-wrapper .page-inner{max-width:[body_width]px;}",
    "@media (min-width: 600px) {",
    ".book.with-summary .book-header.fixed {left: [x]px;}",
    ".book.with-summary .book-body{left:[x]px}}",
    "@media (max-width: 600px) {",
    ".book.with-summary .book-header.fixed {min-width: [x]px;}",
    ".book.with-summary .book-body {min-width: [x]px;}}",
    .open = "[", .close = "]"
  )
}

bd_font <- function(serif = "", sans = "") {
  if (serif != "") {
    serif <- glue(".book.font-family-0 {font-family: [serif];}",
                  .open = "[", .close = "]")
  }
  if (sans != "") {
    sans <- glue(".book.font-family-1 {font-family: [sans];}",
                 .open = "[", .close = "]")
  }
  return(c(serif, sans))
}

bd_google_font <- function(x) {
  if (x == "") return(NULL)
  glue("@import url('https://fonts.googleapis.com/css?family={x}');")
}




