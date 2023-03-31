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

#create manual x and y vectors
shots <- data.frame(x =c(103,102,101,118,109,100,100,91, 107,106),
                    y = c(57,35,43,43,52,51,55,37,57,37),
                    team = c(T,T,T,F,F,F,F,F,F,F))
# viz m ggplot

xdf=dfForPlot(testshot)
ggplot(xdf) +
  annotate_pitch(colour = "white",
                 dimensions = pitch_statsbomb,
                 fill   = "springgreen4",
                 limits = FALSE) +
  ggtriPlayer(103,57)+
  geom_point(aes(x = x, y = y,color=team),
             size = 2) +
  theme_pitch() +
  theme(panel.background = element_rect(fill = "springgreen4")) +
  ggtitle("Simple shotmap",
          "ggsoccer example")

# functions
dfForPlot <- function(vdf) {
  #vdf=testshot
  tmpff=vdf$freeze_frame[[1]][[1]]
  x=sapply(tmpff$location,'[[',1)
  y=sapply(tmpff$location,'[[',2)
  team=tmpff$teammate
  #add shooter
  x=c(x,vdf$location[[1]][1])
  y=c(y,tmpff$location[[1]][2])
  team=c(team,T)
  
  df=data.frame(x,y,team)
  return(df)
}

ggtriPlayer <- function(x,y) {
  df <- data.frame( x=c(x,120,120),
       y=c(y,36,44)) 
  p <- geom_polygon(data=df,aes(x=x,y=y),alpha=0.4)
  return(p)
}

 