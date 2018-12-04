# This is the ui file of a shiny app

library(shiny)

# sets everything displayed in the app page
fluidPage(
  # Application title
  titlePanel("Names of Licensed Pets in Seattle"),
  
  sidebarLayout(
    # sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose a speices:", choices = species), 
      actionButton("update", "Change"),
      hr(), # horizontal ruler
      sliderInput("freq", "Minimum Frequency:",
                  min = 1, max = 50, value = 15),
      sliderInput("max", "Maximum Number of Words displayed:",
                  min = 1, max = 300, value = 100)
    ),
    
    # Show word cloud
    mainPanel(
      #width = 7,
      #height = 20,
      plotOutput("plot")
      #textOutput("message")
    )
  )
)