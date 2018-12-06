library(shiny)

# libraries for word cloud
library(memoise)
library(SnowballC)
library(dplyr)
# libraries for seattle map
library(zipcode)
library(tidyverse)
library(ggplot2)
library(devtools)
library(ggmap)
# libraries for population plot
library(lubridate)

# Make a list of species
species <- list("All available data", "Dog", "Cat", "Goat", "Pig")

# load file
file_path <- "Seattle_Pet_Licenses.csv"
df_original <- read.csv(file_path, stringsAsFactors = F, fileEncoding = "latin1")
colnames(df_original)[3] <- "Name"
colnames(df_original)[7] <- "zip"

# function that filters for a species of choice
filter_by_species <- function(df, selected_species) {
  if (selected_species == "All available data") {
    df <- df
  } else {
    df <- filter(df, Species == selected_species)
  }
}

## word cloud
# function that creates term document matrix (include names and frequency of the names)
getTermMatrix <- memoise(function(selected_species) {
  df <- filter_by_species(df_original, selected_species)
  tb <- table(df$Name)
  tb <- as.data.frame(tb)
  tb <- tb[4: nrow(tb), ] # remove missing names and unwanted punctuation
  tb <- arrange(tb, desc(Freq))
})

## seattle map
# set up google map api
load("my_key.rda")
register_google(key = my_key)

# function that plots pet population onto the map of Seattle by zipcode
make_pic <- function(given_species) {
  data <- filter_by_species(df_original, given_species)
  data <- select(data, zip, Species)
  data$zip <- substr(data$zip, 1, 5) # only retain the first 5 digits of zip code
  counts <- table(data$zip) # results in total number of obervations by zip code
  counts_total <- as.data.frame(counts)
  names(counts_total)[1] <- "zip"
  names(counts_total)[2] <- "count"
  data(zipcode)
  animals <- left_join(counts_total, zipcode, by = "zip") %>%
    filter(state == "WA")
  # plot Seattle map
  map.seattle_city <- qmap("seattle",
    zoom = 11, source = "stamen",
    maptype = "toner", darken = c(.3, "#BBBBBB")
  )
  # plot population by species onto the map
  map.seattle_city +
    geom_point(data = animals, aes(longitude, latitude, color = count), alpha = 0.8, size = 4) +
    scale_color_distiller(palette = "Reds", trans = "reverse")
}

## make a plot of # of new pet licenses vs. year
plot_licenses_per_year <- function(selected_species) {
  # selected_species = "All available data"
  # extract relevant data
  Only_Date <- select(df_original, License.Issue.Date, Species)
  # create `date`` and `Year`` columns
  Only_Date$date <- mdy(Only_Date$License.Issue.Date)
  Only_Date$Year <- year(Only_Date$date)
  
  # create dataframe that summarizes counts by year and by species
  calculate_population <- function(df, selected_species) {
    license_count <- filter_by_species(df, selected_species) %>%
      group_by(Year, Species) %>% 
      summarise(n = n())
  }
  
  pop <- calculate_population(Only_Date, selected_species)
  # plot number of licenses vs. year
  ggplot(pop, aes(Year, n, size = n, color = Species)) +
    geom_point() + 
    labs(x="Year", y = "Number of Licenses issued per year", color = 'Species',size = "License Count") + 
    scale_color_brewer(type = 'div', palette = 'Spectral')
}

