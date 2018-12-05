# This is the server file of a shiny app
library(memoise)
library(tm)
library(wordcloud)
library(SnowballC)
library(dplyr)
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
    wordcloud_rep(names(df_matrix), df_matrix,
      scale = c(3, 0.3), min.freq=0,
      max.words = input$max, rot.per = 0.2, random.order = F,
      colors = brewer.pal(8, "Set2")
    )
  })

  # display a textual output
  output$name_message <- renderText({
    return(paste0(
      "Top three most popular names of the chosen year(s) and pet species are: ",
      names(terms())[1], ", ",
      names(terms())[2], ", ",
      names(terms()[3]), "."
    ))
  })
  ## Server logic for the `Population on map tab`
  # plot seattle map
  output$map <- renderPlot({
    make_pic(input$selection_map)
  })
  output$map_message <- renderText({
    if (input$text_map == "") {
      pop <- zip_counts(input$selection_map, "ALL")
    } else {
      pop <- zip_counts(input$selection_map, input$text_map)
    }
    return(paste0("There are ", pop, " pets of this species licensed in the area."))
  })
  
  ## Server logic for the "Licences issued each year"
  output$plot <- renderPlot({
    plot_licenses_per_year(input$selection_plot)
  })
}
