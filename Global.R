library(shiny)

# libraries for word cloud
library(memoise)
library(tm)
library(wordcloud)
library(SnowballC)
library(dplyr)
# libraries for seattle map
library(zipcode)
library(tidyverse)
library(ggplot2)
library(devtools)
library(ggmap)

# Make a list of species
species <- list("All available data", "Dog", "Cat", "Goat", "Pig")

# load file
file_path <- "Seattle_Pet_Licenses.csv"
df_original <- read.csv(file_path, stringsAsFactors = F, fileEncoding = "latin1")
colnames(df_original)[3] <- "Name"
colnames(df_original)[7] <- "zip"
# filters for dogs or cats
filter_species_df <- function(selected_species) {
  if (selected_species == "All available data") {
    df <- df_original
  } else {
    df <- filter(df_original, Species == selected_species)
  }
}

## word cloud
# make term document matrix
getTermMatrix <- memoise(function(selected_species) {
  df <- filter_species_df(selected_species)
  dfCorpus <- VCorpus(VectorSource(df$Name))

  dfCorpus <- tm_map(dfCorpus, removePunctuation)
  dfCorpus <- tm_map(dfCorpus, removeNumbers)
  dfCorpus <- tm_map(dfCorpus, PlainTextDocument)

  df_matrix <- TermDocumentMatrix(dfCorpus)
  df_matrix <- as.matrix(df_matrix)
  df_matrix <- sort(rowSums(df_matrix), decreasing = TRUE)
})

## seattle map
register_google(key = "AIzaSyBk6QtXerwJ_YXJoYRtl2Kl1uitegbVHy4")

# pets <- select(fm, zip, Species)

make_pic <- function(given_species) {
  data <- filter_species_df(given_species)
  data <- select(data, zip, Species)
  data$zip <- substr(data$zip, 1, 5)
  counts <- table(data$zip)
  counts_total <- as.data.frame(counts)
  names(counts_total)[1] <- "zip"
  names(counts_total)[2] <- "count"
  data(zipcode)
  animals <- left_join(counts_total, zipcode, by = "zip") %>%
    filter(state == "WA")
  map.seattle_city <- qmap("seattle",
    zoom = 11, source = "stamen",
    maptype = "toner", darken = c(.3, "#BBBBBB")
  )
  map.seattle_city +
    geom_point(data = animals, aes(longitude, latitude, color = count), alpha = 0.8, size = 4) +
    scale_color_distiller(palette = "Reds", trans = "reverse")
}

zip_counts <- function(selected_species, given_zip) {
  if (given_zip == "ALL") {
    df <- df_original
  } else {
    df <- filter_species_df(selected_speices) %>%
      filter(substr(df$zip, 1, 5) == given_zip)
  }
  return(nrow(df))
}
