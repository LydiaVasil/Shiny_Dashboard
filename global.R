library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(ggplot2)
library(magrittr)

library(usmap)
library(ggplot2)
library(shiny)
library(readr)
library(plotly)
library(tools)
library(dashboard)
library(corrplot)
library(readr)
library(tidyverse)
library(dplyr)
library(RSocrata)
library(reticulate)

plot_usmap <- function(regions = c("states", "state", "counties", "county"),
                       include = c(),
                       exclude = c(),
                       data = data.frame(),
                       values = "values",
                       theme = theme_map(),
                       labels = TRUE,
                       label_color = "black",
                       ...) {
  
  # check for ggplot2
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("`ggplot2` must be installed to use `plot_usmap`.
         Use: install.packages(\"ggplot2\") and try again.")
  }
  
  # parse parameters
  regions_ <- match.arg(regions)
  geom_args <- list(...)
  
  # set geom_polygon defaults
  if (is.null(geom_args[["colour"]]) & is.null(geom_args[["color"]])) {
    geom_args[["color"]] <- "black"
  }
  
  if (is.null(geom_args[["size"]])) {
    geom_args[["size"]] <- 0.4
  }
  
  # only use "fill" setting if data is not included
  if (is.null(geom_args[["fill"]]) & nrow(data) == 0) {
    geom_args[["fill"]] <- "white"
  } else if (!is.null(geom_args[["fill"]]) & nrow(data) != 0) {
    warning("`fill` setting is ignored when `data` is provided. Use `fill` to color regions with solid color when no data is being displayed.")
  }
  
  # create polygon layer
  if (nrow(data) == 0) {
    map_df <- us_map(regions = regions_, include = include, exclude = exclude)
    geom_args[["mapping"]] <- ggplot2::aes(x = map_df$x, y = map_df$y,
                                           group = map_df$group)
  } else {
    map_df <- map_with_data(data, values = values, include = include, exclude = exclude)
    geom_args[["mapping"]] <- ggplot2::aes(x = map_df$x, y = map_df$y,
                                           group = map_df$group, fill = map_df[, values])
  }
  
  polygon_layer <- do.call(ggplot2::geom_polygon, geom_args)
  
  # create label layer
  if (labels) {
    centroidLabelsColClasses <- c("numeric", "numeric", "character", "character", "character")
    
    if (regions_ == "county" | regions_ == "counties") {
      # add extra column for the county name
      centroidLabelsColClasses <- c(centroidLabelsColClasses, "character")
    }
    
    centroid_labels <- utils::read.csv(system.file("extdata", paste0("us_", regions_, "_centroids.csv"), package = "usmap"),
                                       colClasses = centroidLabelsColClasses,
                                       stringsAsFactors = FALSE)
    
    if (length(include) > 0) {
      centroid_labels <- centroid_labels[
        centroid_labels$full %in% include |
          centroid_labels$abbr %in% include |
          centroid_labels$fips %in% include, ]
    }
    
    if (length(exclude) > 0) {
      centroid_labels <- centroid_labels[!(
        centroid_labels$full %in% exclude |
          centroid_labels$abbr %in% exclude |
          centroid_labels$fips %in% exclude |
          substr(centroid_labels$fips, 1, 2) %in% exclude), ]
    }
    
    if (regions_ == "county" | regions_ == "counties") {
      label_layer <- ggplot2::geom_text(
        data = centroid_labels,
        ggplot2::aes(x = centroid_labels$x,
                     y = centroid_labels$y,
                     label = sub(" County", "", centroid_labels$county)),
        color = label_color)
    } else {
      label_layer <- ggplot2::geom_text(
        data = centroid_labels,
        ggplot2::aes(x = centroid_labels$x,
                     y = centroid_labels$y,
                     label = centroid_labels$abbr),
        color = label_color)
    }
  } else {
    label_layer <- ggplot2::geom_blank()
  }
  
  # construct final plot
  ggplot2::ggplot(data = map_df) + polygon_layer + label_layer + ggplot2::coord_equal() + theme
}

#' This creates a nice map theme for use in plot_usmap.
#' It is borrowed from the ggthemes package located at this repository:
#'   https://github.com/jrnold/ggthemes
#'
#' This function was manually rewritten here to avoid the need for
#'  another package import.
#'
#' All theme functions (i.e. theme_bw, theme, element_blank, %+replace%)
#'  come from ggplot2.
#'
#' @keywords internal
theme_map <- function(base_size = 9, base_family = "") {
  element_blank = ggplot2::element_blank()
  `%+replace%` <- ggplot2::`%+replace%`
  unit <- ggplot2::unit
  
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(axis.line = element_blank,
                   axis.text = element_blank,
                   axis.ticks = element_blank,
                   axis.title = element_blank,
                   panel.background = element_blank,
                   panel.border = element_blank,
                   panel.grid = element_blank,
                   panel.spacing = unit(0, "lines"),
                   plot.background = element_blank,
                   legend.justification = c(0, 0),
                   legend.position = c(0, 0))
}


crimedf <- read_csv('crimedf.csv')
d <- read_csv("d.csv")

plot_usmap(data = d, values = "corr") + 
  scale_fill_continuous(low = "white", high = "red", name = "Correlation of \n Violent Crime and \n Unemployment ", 
                        label = scales::comma) + 
  theme(legend.position = "right", legend.key.size = unit(1.75, "cm"), 
        legend.text = element_text(size = 14, face = 'bold'), legend.title=element_text(size=16, face = 'bold'))


live_crime <- read.socrata(
       "https://data.nashville.gov/resource/qywv-8sc2.json",
       app_token = "IRiSEsUt611O6rGTSRyNF03qz",
       email     = "LydiaVasil24@gmail.com",
       password  = "#1password!"
     )%>% 
  select(incident_type, call_received, address) %>% 
  mutate (address=paste(address,", Nashville, TN"))



