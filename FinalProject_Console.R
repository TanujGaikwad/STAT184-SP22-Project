# Load 2 packages & read in data
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
Ratings_n_Tags <-
  Tags %>%
  left_join(Ratings, by = c("movieId", "userId")) %>%
  left_join(Movies, by = "movieId") %>%
  na.omit() %>%
  select(userId, rating, rating_date, tag, tag_date, title, genres)

head(Ratings_n_Tags, 3)

# Third Chunk: New release_yeah column and modifying movie titles
Ratings_n_Tags <-
  Ratings_n_Tags %>%
  mutate(release_year = str_extract(title, "\\d+"))

Ratings_n_Tags$title <- gsub("\\(\\d+)", "", Ratings_n_Tags$title)
