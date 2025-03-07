renv::use(
  askpass     = "askpass@1.2.1",
  base64enc   = "base64enc@0.1-3",
  bslib       = "bslib@0.9.0",
  cachem      = "cachem@1.1.0",
  cli         = "cli@3.6.4",
  commonmark  = "commonmark@1.9.2",
  cpp11       = "cpp11@0.5.2",
  crayon      = "crayon@1.5.3",
  digest      = "digest@0.6.37",
  fastmap     = "fastmap@1.2.0",
  fontawesome = "fontawesome@0.5.3",
  fs          = "fs@1.6.5",
  generics    = "generics@0.1.3",
  glue        = "glue@1.8.0",
  htmltools   = "htmltools@0.5.8.1",
  httpuv      = "httpuv@1.6.15",
  jquerylib   = "jquerylib@0.1.4",
  jsonlite    = "jsonlite@1.9.1",
  later       = "later@1.4.1",
  lifecycle   = "lifecycle@1.0.4",
  lubridate   = "lubridate@1.9.4",
  magrittr    = "magrittr@2.0.3",
  memoise     = "memoise@2.0.1",
  mime        = "mime@0.12",
  openssl     = "openssl@2.3.2",
  promises    = "promises@1.3.2",
  R6          = "R6@2.6.1",
  rappdirs    = "rappdirs@0.3.3",
  Rcpp        = "Rcpp@1.0.14",
  renv        = "renv@1.1.2",
  rlang       = "rlang@1.1.5",
  sass        = "sass@0.4.9",
  shiny       = "shiny@1.10.0",
  sourcetools = "sourcetools@0.1.7-1",
  sys         = "sys@3.4.3",
  timechange  = "timechange@0.3.0",
  withr       = "withr@3.0.2",
  xtable      = "xtable@1.8-4"
)

renv::embed()

# renv package is for version control of libraries used. you do not need
# anything above this point to run this code but it may be useful in the future
# as libraries evolve and the code breaks.

library(renv)
library(shiny)
library(openssl)
library(lubridate)
    

# Define UI for application
ui <- fluidPage(
  
  # Application title
  
  wellPanel(
    titlePanel(title = "Shiny Exam Example", 
               windowTitle = "Building Shiny App of Exam that hashes student's responses"),
    
  ),
  
  
  # Questions----
  sidebarLayout(
    sidebarPanel(width = 4,
                 
                 fluidRow(h3("Questions:")),
                 fluidRow(
                   radioButtons(inputId = "Q1", 
                                label   = "1) What is the airspeed velocity of an unladen swallow??", 
                                choices = list("roughly 24 miles per hour"         = "A",
                                               "an African or a European swallow?" = "B"), 
                                selected = "B") 
                 ),
                 fluidRow(
                   radioButtons(inputId = "Q2",
                                label   = "2) How much sawdust can you put into a Rice Krispie Treat before people start to notice?",
                                choices = list("None"     = "A",
                                               "Not much" = "B",
                                               "So Much"  = "C",
                                               "LOL"      = "D"), 
                                selected = "C")
                 ), 
                 fluidRow(
                   radioButtons(inputId = "Q3",
                                label   = "3) Would you rather have bionic arms or bionic legs?",
                                choices = list("Arms"  = "A",
                                               "Legs"  = "B",
                                               "What?" = "C"), 
                                selected = "C")
                 ),
                 fluidRow(
                   radioButtons(inputId = "Q4",
                                label   = "4) Is a hotdog in a bun a sandwich?",
                                choices = list("No"  = "A",
                                               "Yes" = "B"), 
                                selected = "A")
                 ), 
                 fluidRow(
                   checkboxGroupInput(inputId = "Q5", 
                                      label   = "5) Choose all numbers less than 10", 
                                      choices = list("13" = "A", 
                                                     "9"  = "B", 
                                                     "pi" = "C", 
                                                     "42" = "D"), 
                                      selected = c("B", "C"), 
                                      inline   = FALSE)
                 ),
                 fluidRow(
                   dateInput(inputId   = "Q6", 
                             label     = "6) On what date was the declaration of independence signed?", 
                             value     = "1776-07-04", 
                             min       = "1700-01-01", 
                             max       = Sys.Date(), 
                             startview = "decade", 
                             format    = "MM d, yyyy")
                 )
    ),
    
    # show the hash output
    # Performance Evaluation----
    mainPanel(width = 8,
              h2("Performance Evaluation by Hash:"), 
             wellPanel(
                fluidRow(h3("Approach 1: Pass (with 100%)/Fail Evaluation")), 
                fluidRow(h4("example formula: md5(paste(\"B,C,B,A,1776-07-04,BC\",..., sep = \",\", collapse = \"\"))")),
                fluidRow(h4("Easiest approach: all questions must be answered correctly for the \"passing\" hash to be returned")),
                fluidRow("md5 Hash:", textOutput("hashTxt"))
              ),
              wellPanel(
                fluidRow(h3("Approach 2: Check (then hash) if questions were answered correctly")),
                fluidRow(h4("example formula\n: md5(paste(TRUE,TRUE,FALSE,TRUE,..., sep = \",\", collapse = \"\"))")),
                fluidRow("md5 Hash:", textOutput("hashAns"))
              ),
              wellPanel(
                fluidRow(h3("Approach 3: Count (then hash) the number of correct answers")), 
                fluidRow(h4("example formula: md5(sum(c(TRUE,TRUE,FALSE,TRUE,...)))")), 
                fluidRow("md5 Hash:", textOutput("hash_nCorrect"))),
              wellPanel(
                fluidRow(
                )
              )
    )
  )
)

# Define server logic 
server <- function(input, output) {
  
  output$hash_used <- renderText({
    input$hashConfig
  })
  
  # hash the answers here (must paste answers together into a single value)
  output$hashTxt <- renderText({
    md5(
      paste(input$Q1, 
            input$Q2,
            input$Q3,
            input$Q4,
            input$Q5,
            input$Q6,
            sep = "", collapse = "")
    )
  })
  
  output$hashAns <- renderText({
    md5(
      paste(
        input$Q1 == "B", 
        input$Q2 == "C",
        input$Q3 == "C",
        input$Q4 == "A",
        all(input$Q5 == c("B", "C")),
        input$Q6 == ymd("1776-07-04"),
        sep = ",", collapse = "")
    )
  })
  
  output$hash_nCorrect <- renderText({
    md5(
      as.character(
        sum(input$Q1 == "B", 
            input$Q2 == "C",
            input$Q3 == "C",
            input$Q4 == "A",
            all(input$Q5 == c("B", "C")),
            input$Q6 == ymd("1776-07-04"))
      )
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
