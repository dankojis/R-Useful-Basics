# Graphs found from http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html#Jitter%20Plot

library(tidyverse)
options(scipen=999)  # turn off scientific notation like 1e+06



### CORRELATION Graphs
#####################################################################################################################
data <- mpg
var1 <- mpg$cty
var2 <- mpg$displ

# XY Scatterplot
ggplot(data, aes(x=var1, y=var2)) +
  geom_point(col='black', size=1) + # aes(col=var) can add 3rd dimension, can add dimension with size too. 
  geom_smooth(method="loess", se=TRUE) + # se=FALSE to turnoff confidence bands 
  #xlim(c(10, 20)) + ylim(c(3, 5)) +  # set X and Y boundaries
  #scale_x_continuous(breaks=seq(0, 40, 5), labels = sprintf("%1.2f%%", seq(0, 40, 5)))+  # set ticks/text on axis
  labs(title="title", subtitle="subtitle", y="y label", x="x label", caption="caption")
  
# Scatterplot with Encirlce (circle certain points)
library(ggalt)
data_select <- filter(data, cty >30)

ggplot(data, aes(x=var1,y=var2))+
  geom_point() +
  geom_encircle(aes(x=cty, y=displ), 
                data=data_select, 
                color="red", 
                size=2, 
                expand=0.08)  # encircle

# Scatterplot with Jitter
ggplot(data,aes( x=cty, y=hwy))+
  geom_jitter()


# Correlogram ( ~ fancy correlation matrix)
library(ggcorrplot)
data <- mtcars
corr <- round(cor(data), 1) # select rows with continuous variables (e.g. cor(data[c(3,5,8,9)]) )
ggcorrplot(corr, hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method="circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title="Correlogram of mtcars", 
           ggtheme=theme_bw) 
####################################################################################################################

### Distribution
data <- mpg
# Histogram
ggplot(data, aes(x=hwy))+
  geom_histogram(aes(fill=class))


# Density
ggplot(mpg, aes(cty)) +
  geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")

# Boxplot
ggplot(mpg, aes(class, cty))+
  geom_boxplot(varwidth=T, fill="plum") + 
  labs(title="Box plot", 
       subtitle="City Mileage grouped by Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")

# Violin Plot
ggplot(mpg, aes(class, cty))+
  geom_violin() + 
  labs(title="Violin plot", 
       subtitle="City Mileage vs Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")

# Bar chart
freqtable <- table(mpg$manufacturer)
df <- as.data.frame.table(freqtable)
ggplot(df, aes(Var1, Freq))+
  geom_bar(stat="identity", width = 0.5, fill="tomato2") + 
  labs(title="Bar Chart", 
       subtitle="Manufacturer of vehicles", 
       caption="Source: Frequency of Manufacturers from 'mpg' dataset") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


### DEVIATION
###################################################################################################################

# Diverging Barcharts (green for positive, red for negative)
    # Data Prep
mtcars$`car name` <- rownames(mtcars)  # create new column for car names
mtcars$mpg_z <- round((mtcars$mpg - mean(mtcars$mpg))/sd(mtcars$mpg), 2)  # compute normalized mpg
mtcars$mpg_type <- ifelse(mtcars$mpg_z < 0, "below", "above")  # above / below avg flag
mtcars <- mtcars[order(mtcars$mpg_z), ]  # sort
mtcars$`car name` <- factor(mtcars$`car name`, levels = mtcars$`car name`)  # convert to factor to retain sorted order in plot.

    # Diverging Barcharts
ggplot(mtcars, aes(x=`car name`, y=mpg_z, label=mpg_z)) + 
  geom_bar(stat='identity', aes(fill=mpg_type), width=.5)  +
  scale_fill_manual(name="Mileage", 
                    labels = c("Above Average", "Below Average"), 
                    values = c("above"="#00ba38", "below"="#f8766d")) + 
  labs(subtitle="Normalised mileage from 'mtcars'", 
       title= "Diverging Bars") + 
  coord_flip()

# Lollipop Chart (same idea as above, more modern looking and has values labeled, no color)
  # uses preprocessed data
ggplot(mtcars, aes(x=`car name`, y=mpg_z, label=mpg_z)) + 
geom_point(stat='identity', fill="black", size=6)  +
  geom_segment(aes(y = 0, 
                   x = `car name`, 
                   yend = mpg_z, 
                   xend = `car name`), 
               color = "black") +
  geom_text(color="white", size=2) +
  labs(title="Diverging Lollipop Chart", 
       subtitle="Normalized mileage from 'mtcars': Lollipop") + 
  ylim(-2.5, 2.5) +
  coord_flip()

# Divergin Dotplot (same idea as barchart, but with red/green dots instead)
ggplot(mtcars, aes(x=`car name`, y=mpg_z, label=mpg_z)) + 
  geom_point(stat='identity', aes(col=mpg_type), size=6)  +
  scale_color_manual(name="Mileage", 
                     labels = c("Above Average", "Below Average"), 
                     values = c("above"="#00ba38", "below"="#f8766d")) + 
  geom_text(color="white", size=2) +
  labs(title="Diverging Dot Plot", 
       subtitle="Normalized mileage from 'mtcars': Dotplot") + 
  ylim(-2.5, 2.5) +
  coord_flip()

# Area Chart

