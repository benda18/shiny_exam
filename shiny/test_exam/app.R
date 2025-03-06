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

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Shiny Exam Example -
             hash of student's responses"),
  
  # Questions
  sidebarLayout(
    sidebarPanel(width = 6, # default = 4
                 fluidRow(
                   radioButtons(inputId = "Q1", 
                                label   = "1) What is the airspeed velocity of an unladen swallow??", 
                                choices = list("roughly 24 miles per hour"         = "A",
                                               "an African or a European swallow?" = "B"), 
                                selected = character(0)) 
                 ),
                 fluidRow(
                   radioButtons(inputId = "Q2",
                                label   = "2) How much sawdust can you put into a Rice Krispie Treat before people start to notice?",
                                choices = list("None"     = "A",
                                               "Not much" = "B",
                                               "So Much"  = "C",
                                               "LOL"      = "D"), 
                                selected = character(0))
                 ), 
                 fluidRow(
                   radioButtons(inputId = "Q3",
                                label   = "3) Would you rather have bionic arms or bionic legs?",
                                choices = list("Arms"  = "A",
                                               "Legs"  = "B",
                                               "What?" = "C"), 
                                selected = character(0))
                 ),
                 fluidRow(
                   radioButtons(inputId = "Q4",
                                label   = "4) Is a hotdog in a bun a sandwich?",
                                choices = list("No"  = "A",
                                               "Yes" = "B"), 
                                selected = character(0))
                 ), 
                 fluidRow(
                   checkboxGroupInput(inputId = "Q5", 
                                      label   = "5) Choose all numbers less than 10", 
                                      choices = list("13" = "A", 
                                                     "9"  = "B", 
                                                     "pi" = "C", 
                                                     "42" = "D"), 
                                      selected = NULL, 
                                      inline   = FALSE)
                 ),
                 fluidRow(
                   dateInput(inputId = "Q6", 
                             label = "6) On what date was the declaration of independence signed?", 
                             value = NULL, 
                             min     = "1400-01-01", 
                             max     = Sys.Date(), 
                             startview = "decade", 
                             format = "MM d, yyyy")
                 )
    ),
    
    # show the hash output
    mainPanel(width = 6,
      "md5 Hash Output:",
      textOutput("hashTxt")
    )
  )
)

# Define server logic 
server <- function(input, output) {
  
  # hash the answers here (must paste answers together into a single value)
  output$hashTxt <- renderText({
    hashOfResponses <- sha256(paste(input$Q1, 
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
