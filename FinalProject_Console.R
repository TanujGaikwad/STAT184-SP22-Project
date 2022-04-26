# LOad 2 packages & read in data
library(tidyverse, warn.conflicts = FALSE)
library(lubridate)

Movies = read.csv("movies.csv")
Ratings = read.csv("ratings.csv")
Tags = read.csv("tags.csv")


# First Chunk: Data Wrangle the Timestamps

Ratings <- 
  Ratings %>%
  mutate(rating_date = as_datetime(timestamp))

Tags <-
  Tags %>%
  mutate(tag_date = as_datetime(timestamp))

head(Ratings, 3)
head(Tags, 3)

# Second Chunk: Joining data where Person RATED & TAGGED a movie
Newtable <-
  Ratings %>%
  full_join(Tags, by = "userId")

NewTable <-
  select(movieId, userId, rating, rating_date, tag, tag_date)
