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
  renv        = "renv@1.1.2",
  rlang       = "rlang@1.1.5",
  sass        = "sass@0.4.9",
  shiny       = "shiny@1.10.0",
  sourcetools = "sourcetools@0.1.7-1",
  sys         = "sys@3.4.3",
  withr       = "withr@3.0.2",
  xtable      = "xtable@1.8-4"
)

renv::embed()

library(renv)
library(shiny)
library(openssl)

# UI
ui <- fluidPage(
  
  # PANEL: title----
  titlePanel("Student Exam - Hashed Responses", 
             windowTitle = "Hashing Exams in Shiny"),
  
  
  sidebarLayout(
    # PANEL: Sidebar----
    sidebarPanel(width = 4,
                 wellPanel(
                   fluidRow(strong("Display hashing function")),
                 ),
                 wellPanel(
                   fluidRow(strong("Display hash output")),
                 )
    ),
    # PANEL: Main----
    mainPanel(width = 8,
              wellPanel(
                tabsetPanel(id = NULL, selected = NULL,
                            type = "pills", #c("tabs", "pills", "hidden"), 
                            header = NULL, footer = NULL,
                            tabPanel(title = "Exam Questions", 
                                     
                            ),
                            tabPanel(title = "Exam Evaluation", 
                                     
                            ),
                            tabPanel(title = "<hold>", 
                                     
                            ),
                ),
                fluidRow(h3("Questions:")),
                # question 1----
                fluidRow(
                  radioButtons(inputId = "Q1", 
                               label   = "1) What is the airspeed velocity of an unladen swallow??", 
                               choices = list("roughly 24 miles per hour"         = "A",
                                              "an African or a European swallow?" = "B"), 
                               selected = character("0")) 
                ),
                # question 2----
                fluidRow(
                  radioButtons(inputId = "Q2",
                               label   = "2) How much sawdust can you put into a Rice Krispie Treat before people start to notice?",
                               choices = list("None"     = "A",
                                              "Not much" = "B",
                                              "So Much"  = "C",
                                              "LOL"      = "D"), 
                               selected = character("0"))
                ), 
                # question 3----
                fluidRow(
                  radioButtons(inputId = "Q3",
                               label   = "3) Would you rather have bionic arms or bionic legs?",
                               choices = list("Arms"  = "A",
                                              "Legs"  = "B",
                                              "What?" = "C"), 
                               selected = character("0"))
                ),
                # question 4----
                fluidRow(
                  radioButtons(inputId = "Q4",
                               label   = "4) Is a hotdog in a bun a sandwich?",
                               choices = list("No"  = "A",
                                              "Yes" = "B"), 
                               selected = character("0"))
                ), 
                # fluidRow(
                #   checkboxGroupInput(inputId = "Q5", 
                #                      label   = "5) Choose all numbers less than 10", 
                #                      choices = list("13" = "A", 
                #                                     "9"  = "B", 
                #                                     "pi" = "C", 
                #                                     "42" = "D"), 
                #                      selected = c("B", "C"), 
                #                      inline   = FALSE)
                # ),
                # fluidRow(
                #   dateInput(inputId   = "Q6", 
                #             label     = "6) On what date was the declaration of independence signed?", 
                #             value     = "1776-07-04", 
                #             min       = "1700-01-01", 
                #             max       = Sys.Date(), 
                #             startview = "decade", 
                #             format    = "MM d, yyyy")
                # )
              ),
    )
  )
)

# Server
server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
