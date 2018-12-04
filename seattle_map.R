setwd("Documents/INFO 201/404notfound")
getwd()

install.packages("ggpubr")
library(zipcode)
library(tidyverse)
library(maps)
library(viridis)
library(ggthemes)
library(devtools)
library(ggplot2)
library(ggmap)
library(png)
library(grid)
library(ggpubr)
library(jpeg)
library(albersusa)

fm<-seattlePetLicenses <- read_csv("seattle-pet-licenses.csv")
names(fm)[7]<-"zip"
pets <- select(fm, zip, Species)

cats <- filter(pets, pets$Species == "Cat")
dogs <- filter(pets, pets$Species == "Dog")

make_pic <- function(given_species) {
  species <- tolower(given_species)
  if (species == "cats" || species == "cat" ) {
    data <- cats
  } else {
    data <- dogs
  }
  counts = table(data$zip)
  counts_total = as.data.frame(counts)
  names(counts_total)[1]<-"zip"
  names(counts_total)[2]<-"count"
  data(zipcode)
  animals<- left_join(counts_total, zipcode, by='zip')
  img <- readJPEG("sea_map.jpg")
  ggplot(animals,aes(longitude,latitude)) +
    background_image(img) +
    geom_point(aes(color = count),size=4,alpha=0.5) +
    xlim(-123,-122)+ylim(47.3,47.8)
}



zip_counts <- function(given_zip) {
  cats_in_zip <- nrow(filter(cats, cats$zip == given_zip))
  dogs_in_zip <- nrow(filter(dogs, dogs$zip == given_zip))
  print(paste0("There are ", cats_in_zip, " cats and ", dogs_in_zip, " dogs in this area."))
}
zip_counts("98105")
make_pic("dog")
