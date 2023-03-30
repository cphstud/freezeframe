library(mongolite)
library(tidyverse)
library(ggplot2)
library(ggsoccer)


# hente database fra mongo ned i R
con <- mongo(
  url = "mongodb://127.0.0.1:27017",
  db="statsbomb",
  collection = "events"
)

goalTryFem <- con$find(query='{"gender": "female", 
  "type.name": "Shot", 
  "shot.outcome.name": {"$ne":"Goal"} 
  }')

  
### DATAWRANGLING
shots <- data.frame(x = c(90, 85, 82, 78, 83, 74, 94, 91),
                    y = c(43, 40, 52, 56, 44, 71, 60, 54))

#create manual x and y vectors
shots <- data.frame(x =c(103,102,101,118,109,100,100,91, 107,106),
                    y = c(57,35,43,43,52,51,55,37,57,37),
                    team = c(T,T,T,F,F,F,F,F,F,F))
# viz m ggplot

ggplot(shots) +
  annotate_pitch(colour = "white",
                 dimensions = pitch_statsbomb,
                 fill   = "springgreen4",
                 limits = FALSE) +
  geom_point(aes(x = x, y = y,color=team),
             size = 2) +
  theme_pitch() +
  theme(panel.background = element_rect(fill = "springgreen4")) +
  ggtitle("Simple shotmap",
          "ggsoccer example")

# functions

 