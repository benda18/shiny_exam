
renv::embed()

library(renv)
library(shiny)

# UI
ui <- fluidPage(
  
  # Application title
  titlePanel("Student Exam - Hashed Responses"),
  
  
  sidebarLayout(
    sidebarPanel(
      
    ),
    mainPanel(
      
    )
  )
)

# Server
server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
