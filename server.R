# This is the server file of a shiny app
library(wordcloud)
library(SnowballC)
library(shiny)

# Define server logic
server <- function(input, output) {
  ## Server logic for the `Names as word cloud tab`
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        # display this message when the graph is still rendering
        setProgress(message = "Processing corpus...")
        x <- getTermMatrix(input$selection_wordcloud)
      })
    })
  })

  # make a wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)

  # plot the word cloud
  output$word_cloud <- renderPlot({
    df_matrix <- terms()
    wordcloud_rep(df_matrix$Var1, df_matrix$Freq,
      scale = c(3, 0.3), min.freq=0,
      max.words = input$max, rot.per = 0.2, random.order = F,
      colors = brewer.pal(8, "Set2")
    )
  })

  # display a textual output
  output$name_message <- renderText({
    return(paste0(
      "Top three most popular names of the chosen pet species are: ",
      terms()$Var1[1], ", ",
      terms()$Var1[2], ", ",
      terms()$Var1[3], "."
    ))
  })
  
  ## Server logic for the `Population on map tab`
  # plot seattle map
  output$map <- renderPlot({
    make_pic(input$selection_map)
  })

  ## Server logic for the "Licences issued each year"
  output$plot <- renderPlot({
    plot_licenses_per_year(input$selection_plot)
  })
}
