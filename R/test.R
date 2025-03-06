renv::use(
  askpass     = "askpass@1.2.1",
  base64enc   = "base64enc@0.1-3",
  bslib       = "bslib@0.9.0",
  cachem      = "cachem@1.1.0",
  cli         = "cli@3.6.4",
  commonmark  = "commonmark@1.9.2",
  crayon      = "crayon@1.5.3",
  digest      = "digest@0.6.37",
  fastmap     = "fastmap@1.2.0",
  fontawesome = "fontawesome@0.5.3",
  fs          = "fs@1.6.5",
  glue        = "glue@1.8.0",
  htmltools   = "htmltools@0.5.8.1",
  httpuv      = "httpuv@1.6.15",
  jquerylib   = "jquerylib@0.1.4",
  jsonlite    = "jsonlite@1.9.1",
  later       = "later@1.4.1",
  lifecycle   = "lifecycle@1.0.4",
  magrittr    = "magrittr@2.0.3",
  memoise     = "memoise@2.0.1",
  mime        = "mime@0.12",
  openssl     = "openssl@2.3.2",
  promises    = "promises@1.3.2",
  R6          = "R6@2.6.1",
  rappdirs    = "rappdirs@0.3.3",
  Rcpp        = "Rcpp@1.0.14",
  renv        = "renv@1.1.1",
  rlang       = "rlang@1.1.5",
  sass        = "sass@0.4.9",
  shiny       = "shiny@1.10.0",
  sourcetools = "sourcetools@0.1.7-1",
  sys         = "sys@3.4.3",
  withr       = "withr@3.0.2",
  xtable      = "xtable@1.8-4"
)

library(renv)

#install("openssl")
#install("shiny")

library(openssl)
library(shiny)

status()
snapshot()


n <- 3
x <- 4

4^3

expand.grid(Q1 = 1:4, 
            Q2 = 1:4, 
            Q3 = 1:4)
