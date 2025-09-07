# Load 2 packages & read in data
library(tidyverse, warn.conflicts = FALSE)
library(lubridate)
options(dplyr.summarise.inform = FALSE)

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

head(Ratings_n_Tags, 3)

# Data Visualization: First Graph
# Top 10 Rated Movie Genres (10 Most Frequently Rated Genres)

#Quick Data Wrangle to get the top 10 Genres
GenreCounts <-
  Ratings_n_Tags %>%
  group_by(genres) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  head(10)

ggplot(GenreCounts, aes(x = reorder(genres, -count), y = count)) +
  geom_bar(stat = "identity") +
  labs(y = "Count", x = "Genre", title = "Top 10 Rated Genres") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Data Visualization: Second Graph
# Determine Count of each rating

#Quick Data Wrangle to get count of all ratings
RatingsCount <-
  Ratings_n_Tags %>%
  group_by(rating) %>%
  summarise(count = n()) %>%
  arrange(desc(rating))

ggplot(RatingsCount, aes(x = reorder(rating, -rating), y = count, fill = as.factor(rating))) +
  geom_bar(stat = "identity") +
  labs(y = "Count", x = "Rating", title = "Count of Ratings Given to Movies", fill = "Rating", color = "Rating")

# Resources Listed