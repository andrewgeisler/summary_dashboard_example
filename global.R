library(shiny)
library(flexdashboard)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(lubridate)
library(config)
library(RPostgreSQL)
library(leaflet)
library(geojsonio)
library(zoo)
library(purrr)
library(DT)

theme <- theme_minimal() +
  theme(
    text = element_text(size = 10, color = "#666666", family = "Arial Rounded MT Bold"),
    axis.text = element_text(size = rel(0.8), color = "#666666"),
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 1),
    axis.ticks = element_line(colour = "#e8e8e8"),
    legend.key = element_blank(),
    legend.position = "none",
    panel.grid.major = element_line(color = "#e8e8e8", size = 0.2),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )
theme_set(theme)

walk(list.files("functions", full.names = T), source)

source('R/extract_and_transform_measures.R')

shapes_dma <- geojsonio::geojson_read("shapes/n.json", what = "sp")

periods <- stats_summary %>%
  arrange(desc(start_date)) %>%
  filter(start_date >= today()-weeks(54)) %>%
  select(label, start_date) %>%
  mutate(current = case_when(start_date == floor_date(today()-months(1), 'month')~ TRUE, TRUE~FALSE)) %>%
  unique()


# MODULES -----------------------------------------------------------------

source('modules/bar_chart_module.R')
source('modules/gauge_module.R')
source('modules/map_module.R')
source('modules/text_box_module.R')
source('modules/trend_module.R')


# Selection Widgets -------------------------------------------------------

period_select_wid <- selectInput(
  "period",
  label = NULL,
  choices = periods$label,
  selected = periods$label[periods$current == T],
  width = "150px",
  size = NULL
)

trend_meaure_select <- selectInput(
  "trend_measure",
  label =  NULL,
  width = 200,
  choices =  measure_list,
  selected = measure_list$`Active Users`
)

geo_meaure_select <- selectInput(
  "geo_measure",
  label =  NULL,
  width = 175,
  choices = list(
    "Active Users" = 'value',
    "Prior Year Comparison" = 'comp_prior_year',
    "Prior 4 Week Avg Comparison" = 'comp_rolling_avg'
  ),
  selected = 'value'
)
