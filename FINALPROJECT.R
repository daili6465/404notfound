Pet_Data <- read.csv("~/Documents/Seattle_Pet_Licenses.csv", stringsAsFactors = FALSE)
View(Pet_Data)
library(dplyr)
Only_Date <- select(Pet_Data, License.Issue.Date, Species, Primary.Breed, Secondary.Breed)
View(Only_Date)
library(lubridate)
mm/dd/yyy
library(ggplot2)
library(tidyr)

data <- readRDS("~/Documents/Seattle_Pet_Licenses.csv", stringsAsFactors = FALSE)
data$Region <- as.factor(data$Region)

Only_Date$date <- lubridate::mdy(Only_Date$License.Issue.Date)
Only_Date$month <- lubridate::month(Only_Date$date)
Only_Date$dayofwk <- lubridate::wday(Only_Date$date)
Only_Date$dayofmonth <- lubridate::day(Only_Date$date)
Only_Date$Month <- lubridate::month(Only_Date$date, label=TRUE)
Only_Date$Weekday <- lubridate::wday(Only_Date$date, label=TRUE)        
Only_Date$Year <- lubridate::year(Only_Date$date)

#x = time, y = pets/population 

C <- subset(Only_Date, Species == "Cat")
D <- subset(Only_Date, Species == "Dog")
G <- subset(Only_Date, Species == "Goat")
P <- subset(Only_Date, Species == "Pig")
View(D)

Popp <- Only_Date %>% 
group_by(Year) %>% 
  summarise(n = n())

#Pig population
P$Population <- 6
#Goat populations by year
G2016 <- subset(G, Year == "2016")
G2016$Population <- 2
G2017 <- subset(G, Year == "2017")
G2017$Population <- 14
G2018 <- subset(G, Year == "2018")
G2018$Population <- 13

#Cat population by year
C2003 <- subset(C, Year == "2003")
C2003$Population <- 1
C2006 <- subset(C, Year == "2006")
C2006$Population <- 2
C2014 <- subset(C, Year == "2014")
C2014$Population <- 4
C2015 <- subset(C, Year == "2015")
C2015$Population <- 141
C2016 <- subset(C, Year == "2016")
C2016$Population <- 2265
C2017 <- subset(C, Year == "2017")
C2017$Population <- 6742
C2018 <- subset(C, Year == "2018")
C2018$Population <- 8198

#Dog population
D2004 <- subset(D, Year == "2004")
D2004$Population <- 1
D2008 <- subset(D, Year == "2008")
D2008$Population <- 3
D2011 <- subset(D, Year == "2011")
D2011$Population <- 1
D2012 <- subset(D, Year == "2012")
D2012$Population <- 2
D2014 <- subset(D, Year == "2014")
D2014$Population <- 23
D2015 <- subset(D, Year == "2015")
D2015$Population <- 297
D2016 <- subset(D, Year == "2016")
D2016$Population <- 3632
D2017 <- subset(D, Year == "2017")
D2017$Population <- 12637
D2018 <- subset(D, Year == "2018")
D2018$Population <- 18188 
# Added Populations together for all years
Population_Goat <- rbind.data.frame(G2016, G2017, G2018)
Population_Cat <- rbind.data.frame(C2003, C2006, C2014,C2015,C2016, C2017, C2018)
Population_Dog <- rbind.data.frame(D2003, D2004, D2008, D2011, D2012, D2014,
                                   D2015, D2016, D2017, D2018)
#Pets
Population_Pets <- rbind.data.frame(Population_Cat, Population_Dog, Population_Goat, P)
View(Population_Pets)
install.packages("gapminder")
if (!require(devtools))
  install.packages("cowplot")
devtools::install_github("dgrtwo/gganimate")
library(gapminder)
library(gganimate)

Population_Pets$id <- seq.int(nrow(Population_Pets))

# Create the plot
Pet_Plot <- ggplot(Population_Pets, aes(Year, Population, size = Population, color = Species, frame = Month)) +
  geom_point()+ 
  labs(x="Month", y = "Population of Pets", color = 'Species',size = "Population") + 
  scale_color_brewer(type = 'div', palette = 'Spectral')

Animation <- ggplotly(Pet_Plot) %>%
  animation_opts(frame = 12,
                 easing = "linear",
                 redraw = FALSE)


