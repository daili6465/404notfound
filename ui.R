# This is the ui file of a shiny app

library(shiny)

# sets everything displayed in the app page
fluidPage(
  # Application title
  titlePanel("Seattle Pet Licenses"),

  mainPanel(
    column(
      12,
      tabsetPanel(
        tabPanel(
          "Licenses issued by year",
          fluidRow(
            plotOutput("plot"),
            hr(),
            wellPanel(
              selectInput("selection_plot", "Choose a species:", choices = species)
            )
          )
        ),
        tabPanel(
          "Population on map",
          fluidRow(
            hr(),
            plotOutput("map"),
            # textOutput("map_message"),
            hr(),
            wellPanel(
              selectInput("selection_map", "Choose a species:", choices = species)
              # textInput("text_map", HTML("Enter a 5-digit zip code within the City
                                         # of Seattle:<br/>(Enter \"ALL\" for all records available)"))
            )
          )
        ),
        tabPanel(
          "Names as word cloud",
          fluidRow(
            plotOutput("word_cloud"),
            textOutput("name_message"),
            hr(),
            column(
              5,
              selectInput("selection_wordcloud", "Choose a speices:", choices = species),
              br(),
              textOutput("prompt"),
              actionButton("update", "Update")
            ),

            column(4,
              offset = 1,
              # sliderInput("freq", "Minimum Frequency:",
               #  min = 1, max = 30, value = 10
              # ),
              sliderInput("max", "Maximum Number of Words displayed:",
                min = 1, max = 100, value = 50
              )
            )
          )
        )
      )
    )
  )
)
