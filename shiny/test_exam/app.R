renv::use(
  openssl     = "openssl@2.3.2",
  renv        = "renv@1.1.1",
  shiny       = "shiny@1.10.0"
)


library(shiny)
library(openssl)
library(renv)

#renv::embed()

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Preposterous Examination"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 6, # default = 4
                 fluidRow(
                   radioButtons(inputId = "Q1", 
                                label   = "1) What is the airspeed velocity of an unladen swallow??", 
                                choices = list("roughly 24 miles per hour"         = "A",
                                               "an African or a European swallow?" = "B")) 
                 ),
                 fluidRow(
                   radioButtons(inputId = "Q2",
                                label   = "2) How much sawdust can you put into a Rice Krispie Treat before people start to notice?",
                                choices = list("None"     = "A",
                                               "Not much" = "B",
                                               "So Much"  = "C",
                                               "LOL"      = "D"))
                 )
                 
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #plotOutput("distPlot")
      "Hash Output:",
      textOutput("hashTxt"),
      
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # output$distPlot <- renderPlot({
  #     # generate bins based on input$bins from ui.R
  #     # x    <- faithful[, 2]
  #     # bins <- seq(min(x), max(x), length.out = input$bins + 1)
  # 
  #     # # draw the histogram with the specified number of bins
  #     # hist(x, breaks = bins, col = 'darkgray', border = 'white',
  #     #      xlab = 'Waiting time to next eruption (in mins)',
  #     #      main = 'Histogram of waiting times')
  # })
  
  output$hashTxt <- renderText({
    hashOfResponses <- openssl::sha256(paste(input$Q1, input$Q2, sep = "", collapse = ""))
    
  })
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
