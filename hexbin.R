library(tidyverse)
library(h3jsr) ## https://github.com/obrl-soil/h3jsr
library(mapdeck)
library(sf)

H3_RESOLUTION <-4

## Unzip crash data. Creates ./QLD_ROAD_CRASH.csv
unzip("./DP_QLD_ROAD_CRASH.zip")

road_crashes <- read_csv(
  "./QLD_ROAD_CRASH.csv",
  col_types = cols(
    .default = col_character(),
    `Count casualty fatality` = col_double(),
    `Count casualty hospitalised` = col_double(),
    `Count casualty medically treated` = col_double(),
    `Count casualty minor injury` = col_double(),
    `Count casualty total` = col_double(),
    `Crash DCA code` = col_double(),
    `Crash hour` = col_double(),
    `Crash year` = col_double(),
    `Crash reference number` = col_double(),
    Longitude = col_double(),
    Latitude = col_double()
  )
)

## A helper:
lon_lat_to_point <- function(lon, lat) {
  purrr::map2(
    lon,
    lat,
    ~ sf::st_point(c(.x, .y))
  ) %>%
    sf::st_sfc(crs = 4326)
}

## begin code posted to twitter:
## Could take  up to 60 seconds
road_crashes_hexbinned <-
  road_crashes %>%
  mutate(
    location = lon_lat_to_point(
      Longitude,
      Latitude
    ),
    h3_index = point_to_h3(
      location,
      H3_RESOLUTION
    )
  ) %>%
  group_by(h3_index) %>%
  summarise(n_crashes = n()) %>%
  mutate(outline = h3jsr::h3_to_polygon(h3_index)) %>%
  st_sf(crs = 4326) ## lon lat Coordinate Reference System

## make a mapdeck plot of crash density
road_crashes_hexbinned %>%
  mutate(log_crashes = log(n_crashes)) %>% ## makes hex colours a bit more interesting
  mapdeck(
    style = mapdeck_style("dark"),
    token = Sys.getenv("MAPBOX_TOKEN"),
    height = "100vh"
  ) %>%
  add_polygon(fill_colour = "log_crashes")
