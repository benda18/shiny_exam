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

library(shiny)
library(openssl)
library(renv)

renv::embed()

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Shiny Exam Example -
             hash of student's responses"),
  
  # Questions
  sidebarLayout(
    sidebarPanel(width = 4, # default = 4
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
                   # for open-ended questions like this take heed: there will be
                   # many more combinations of correct and incorrect answers
                   # when you go to check hashes.
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
    mainPanel(width = 8,
              "md5 Hash Outputs:", 
              wellPanel(
                fluidRow(h3("Hash verbatim answers")), 
                fluidRow(h4("md5(paste(\"A,B,A,July 4, 1776\",..., sep = \",\", collapse = \"\"))")),
                fluidRow(textOutput("hashTxt"))
              ), 
              wellPanel(
                fluidRow(h3("Check (then hash) if questions were answered correctly")),
                fluidRow(h4("md5(paste(TRUE,TRUE,FALSE,TRUE,..., sep = \",\", collapse = \"\"))")),
              ),
              wellPanel(
                fluidRow(h3("Count (then hash) the number of correct answers")), 
                fluidRow(h4("md5(sum(TRUE,TRUE,FALSE,TRUE,...))")))
    )
  )
)

# Define server logic 
server <- function(input, output) {
  
  # hash the answers here (must paste answers together into a single value)
  output$hashTxt <- renderText({
    hashOfResponses <- md5(paste(input$Q1, 
                                    input$Q2,
                                    input$Q3,
                                    input$Q4,
                                    input$Q5,
                                    input$Q6,
                                    sep = "", collapse = ""))
  })
  
  output$hashAns <- renderText({
    hashIfCorrect <- md5(paste(input$Q1, 
                                  input$Q2,
                                  input$Q3,
                                  input$Q4,
                                  input$Q5,
                                  input$Q6,
                                  sep = "", collapse = ""))
  })
  
  output$hash_nCorr <- renderText({
    hashNCor <- md5(paste(input$Q1, 
                             input$Q2,
                             input$Q3,
                             input$Q4,
                             input$Q5,
                             input$Q6,
                             sep = "", collapse = ""))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
