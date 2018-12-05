
#libraries for plot to run
install.packages("plotly")
library(plotly)


# Create the plot
Pet_Plot <- ggplot(pop, aes(Year, n, size = n, color = Species, frame = Year)) + 
  geom_point()+ 
  labs(x="Year", y = "Population of Pets Licenses", color = 'Species',size = "License Count") + 
  scale_color_brewer(type = 'div', palette = 'Spectral')

Animation <- ggplotly(Pet_Plot)

Animation
htmlwidgets::saveWidget(Animation, "PetPlot.html")