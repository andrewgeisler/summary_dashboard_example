library(tidyverse)
library(lubridate)
library(config)
library(RPostgreSQL)
library(purrr)
library(zoo)

# Randomize Function ------------------------------------------------------
adjust_num <- function(x) {
  x_adjusted = x * runif(1, .1, 3)
  return(x_adjusted)
}

random_text <- function(df, field) {

  randomize_text <- function(x) {
    length <- str_length(x)
    new_word <- c(LETTERS,letters) %>%
      sample(length, replace = T) %>%
      str_c(collapse='')
    return(new_word)
  }

  unique_values <- df %>% select(!!field) %>% unique()
  unique_values <- unique_values %>%
    mutate(new_field = map(!!field, randomize_text)) %>%
    unnest()

  df <- df %>%
    ungroup() %>%
    left_join(unique_values) %>%
    select(-!!field)

  return(df)
}

shuffle_geo <- function(df) {
  dma_table <- df %>% select(dma_code, dma_name) %>% unique()
  unique_codes <- dma_table %>% pull(dma_code)
  new <- sample(unique_codes, length(unique_codes))

  df$dma_code = new
  df %>%
    select(-dma_name) %>%
    left_join(dma_table)
}

# LOAD RAW DATA -----------------------------------------------------------

stats_summary <- read_csv('data/stats_summary.csv')
stats_platform <- read_csv('data/stats_platform.csv') 
stats_dma <- read_csv('data/stats_dma.csv')
top_activities <- read_csv('data/top_activities.csv')

# Randomize Data ----------------------------------------------------------
stats_summary <- stats_summary %>%
  mutate_if(is.numeric, adjust_num)

stats_platform <- stats_platform %>%
  mutate_if(is.numeric, adjust_num)

stats_dma <- stats_dma %>%
    mutate(dma_code = as.character(dma_code)) %>%
    mutate_if(is.numeric, adjust_num)

stats_dma <- stats_dma %>%
  split(str_c(.$start_date, .$account_type)) %>%
  map(shuffle_geo) %>%
  bind_rows()

top_activities <- top_activities %>%
  mutate_if(is.numeric, adjust_num) %>%
  group_by(start_date, account_type) %>%
  arrange(start_date, desc(video_plays)) %>%
  mutate(rank_video_plays = row_number()) %>%
  ungroup() %>%
  random_text(quo(title)) %>%
  rename(title = new_field)


# Process Data ------------------------------------------------------------
stats_summary <- stats_summary %>%
  mutate(
    total_minutes = total_seconds/60,
    week_label = format(start_date, '%Y-%m-%d'),
    avg_minutes_per_active_day = avg_seconds_per_active_day/60,
    avg_percent_completion = avg_percent_completion*100,
    avg_daily_completion_rate = avg_daily_completion_rate*100
  ) %>%
  select(
    -total_seconds,
    -week_label
  )

stats_platform <- stats_platform  %>%
  mutate(week_label = format(start_date, '%Y-%m-%d'))

stats_dma <- stats_dma %>%
  mutate(week_label = format(start_date, '%Y-%m-%d'), dma_code = as.numeric(dma_code))

top_activities <- top_activities %>%
  mutate(week_label = format(start_date, '%Y-%m-%d'))


# Add calculated measures to stats table ----------------------------------
stats_summary <- stats_summary %>%
  mutate(
    winback_users = active_users-retained_users-active_users_new,
    activation_rate = active_users_new/new_users,
    retention_rate = retained_users/active_users_prior,
    churn_rate = churned_users/active_users_prior,
    utilization_rate_users = case_when(
      account_type == 'account_type_a'~ active_users/unisverse_account_type_a,
      account_type == 'account_type_b' ~  active_users/unisverse_account_type_b,
      TRUE ~ 0)
  )


# Pivot Longer for tidyer data --------------------------------------------
stats_summary <- stats_summary %>%
  pivot_longer(cols = new_users:utilization_rate_users, names_to = 'measure') %>%
  arrange(account_type, measure, start_date) %>%
  filter(!is.na(value))

# Calculate comparison metrics --------------------------------------------

stats_summary <- stats_summary %>%
  mutate(
    label = format(start_date, '%Y-%m-%d'),
    week_of_year = isoweek(start_date),
    year = year(start_date)
  ) %>%
  arrange(account_type, measure, week_of_year, year) %>%
  group_by(account_type, measure, week_of_year) %>%
  mutate(
    comp_prior_year = (value/lag(value))-1
  ) %>%
  group_by(account_type, measure) %>%
  arrange(account_type, measure, start_date) %>%
  mutate(
    rolling_avg = rollmean(value, 4, align = 'right', fill = NA),
    rolling_avg = lag(rolling_avg),
    comp_rolling_avg = (value/rolling_avg)-1
  ) %>%
  ungroup()

stats_summary <- stats_summary %>%
  mutate(
    comp_prior_year = replace_na(comp_prior_year, 0),
    rolling_avg = replace_na(rolling_avg, 0),
    comp_rolling_avg = replace_na(comp_rolling_avg, 0)
  )

# Summarize Plaform Breakdown -------------------------------------------
stats_platform <- stats_platform %>%
  # mutate(signup_platform_id = platform) %>%
  select(
    start_date,
    platform,
    account_type,
    active_users
  ) %>%
  pivot_longer(cols = active_users, names_to = 'measure') %>%
  mutate(label = format(start_date, '%Y-%m-%d'))


# Top Content Breakdown ---------------------------------------------------
top_activities <- top_activities %>%
  select(
    start_date,
    account_type,
    title,
    video_plays
  ) %>%
  pivot_longer(cols = video_plays, names_to = 'measure') %>%
  mutate(label = format(start_date, '%Y-%m-%d'))

stats_dma <- stats_dma %>%
  select(-week_label, -cdc_timestamp, -end_date)

stats_dma <- stats_dma %>%
  select(
    start_date,
    account_type,
    dma_code,
    dma_name,
    new_users:unisverse_account_type_b
  ) %>%
  mutate(
    winback_users = active_users-retained_users-active_users_new,
    activation_rate = active_users_new/new_users,
    retention_rate = retained_users/active_users_prior,
    churn_rate = churned_users/active_users_prior,
    utilization_rate_users = case_when(
      account_type == 'account_type_a'~ active_users/unisverse_account_type_a,
      account_type == 'account_type_b' ~  active_users/unisverse_account_type_b,
      TRUE ~ 0)
  )

stats_dma <- stats_dma %>%
  pivot_longer(cols = new_users:utilization_rate_users, names_to = 'measure') %>%
  arrange(account_type, measure, start_date) %>%
  filter(!is.na(value)) %>%
  mutate(
    label = format(start_date, '%Y-%m-%d'),
    week_of_year = isoweek(start_date),
    year = year(start_date)
  ) %>%
  arrange(account_type, dma_code, dma_name, measure, week_of_year, year) %>%
  group_by(account_type, dma_code, dma_name, measure, week_of_year) %>%
  mutate(
    comp_prior_year = (value/lag(value))-1
  ) %>%
  group_by(account_type, dma_code, dma_name, measure) %>%
  arrange(account_type, dma_code, dma_name, measure, start_date) %>%
  mutate(
    rolling_avg = rollmean(value, 4, align = 'right', fill = NA),
    rolling_avg = lag(rolling_avg),
    comp_rolling_avg = (value/rolling_avg)-1
  ) %>%
  ungroup()


# Create List for Measure Dropdown ----------------------------------------
measure_list <- stats_summary %>%
  filter(!measure %in% c(
    'unisverse_account_type_a',
    'unisverse_account_type_b',
    'universe_students',
    'universe_schools',
    'utilization_rate_users',
    'active_users_prior'
  )) %>%
  pull(measure) %>%
  unique() %>%
  as.list()

names(measure_list) <-  stats_summary %>%
  filter(!measure %in% c(
    'unisverse_account_type_a',
    'unisverse_account_type_b',
    'universe_students',
    'universe_schools',
    'utilization_rate_users',
    'active_users_prior'
  )) %>%
  pull(measure) %>%
  unique() %>%
  str_replace_all('_', ' ') %>%
  str_to_title()
