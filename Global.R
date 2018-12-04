library(memoise)
library(tm)
library(wordcloud)
library(SnowballC)
library(dplyr)
library(shiny)

# The list of species
species <- list("All available data", "Dog", "Cat")

# load file
setwd("~/workspace/Info 201/Final project/")
file_path <- "Seattle_Pet_Licenses.csv"
df_original <- read.csv(file_path, stringsAsFactors = F, fileEncoding="latin1")
colnames(df_original)[3] <- "Name"

# filters for dogs or cats
filter_species_df <- function(selected_species) {
  if (selected_species == "All available data") {
    df <- df_original
  } else {
    df <- filter(df_original, Species == selected_species)
  }
}
getTermMatrix <- function(selected_species) {
  df <- filter_species_df(selected_species)
  dfCorpus = VCorpus(VectorSource(df$Name))
  
  dfCorpus <- tm_map(dfCorpus, removePunctuation)
  dfCorpus <- tm_map(dfCorpus, removeNumbers)
  dfCorpus <- tm_map(dfCorpus, PlainTextDocument)
  
  df_matrix <- TermDocumentMatrix(dfCorpus)
  df_matrix <- as.matrix(df_matrix)
  df_matrix <- sort(rowSums(df_matrix), decreasing = TRUE)
}
