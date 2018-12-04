# This is the server file of a shiny app
library(memoise)
library(tm)
library(wordcloud)
library(SnowballC)
library(dplyr)
library(shiny)

# Define server logic required to draw a word cloud
server <- function(input, output) {
  # Define a reactive expression for the document term matrix
  terms <- reactive ({
    # change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        # display this message when the graph is still rendering
        setProgress(message = "Processing corpus...")
        x <- getTermMatrix(input$selection)
      })
    })
  })
  
  # make a wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  # plot the word cloud
  output$plot <- renderPlot({
    df_matrix <- terms()
    wordcloud_rep(names(df_matrix), df_matrix, scale = c(3, 0.3), min.freq = input$freq, 
                  max.words = input$max, rot.per = 0.2, random.order = F,
                  colors = brewer.pal(8, "Set2"))
  })
}
  # display a textual output
  #output$message <- renderText({
    #return(paste("In 2016, there were", number_of_reports, "cases of UFO sightings reported in the selected state(s)."))
  #})
#}