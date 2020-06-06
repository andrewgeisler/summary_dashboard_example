library(shiny)
library(shinythemes)
library(DT)
library(scales)



shinyServer(function(input, output) {

  period_select <- reactive(input$period)

  trend_measure_select <- reactive(input$trend_measure)
  trend_measure_type_select <- reactive(input$trend_measure_type)

  map_geo_select <- reactive(input$geo_measure)

  output$period_selected <- renderText(
    str_c('Summary: Week of ', {input$period})
  )
  output$period_selected2 <- renderText(
    str_c('Summary: Week of ', {input$period})
  )


  # Create Primary Measure Text Box Outputs ---------------------------------
  pwalk(
    expand.grid(c('account_type_a','account_type_b'), unique(stats_summary$measure), stringsAsFactors = F),
    ~ callModule(
      module = text_box_server,
      id = str_to_lower(str_c(.y, 'box',.x, sep = '_')),
      df = stats_summary %>% filter(measure == .y, account_type == .x),
      period_select = period_select
    )
  )

  pwalk(
    expand.grid(c('account_type_a','account_type_b'), unique(stats_summary$measure), stringsAsFactors = F),
    ~ callModule(
      module = text_box_server_comp_year,
      id = str_to_lower(str_c(.y, 'box_py',.x, sep = '_')),
      df = stats_summary %>% filter(measure == .y, account_type == .x),
      period_select = period_select
    )
  )

  pwalk(
    expand.grid(c('account_type_a','account_type_b'), unique(stats_summary$measure), stringsAsFactors = F),
    ~ callModule(
      module = text_box_server_comp_period,
      id = str_to_lower(str_c(.y, 'box_pp',.x, sep = '_')),
      df = stats_summary %>% filter(measure == .y, account_type == .x),
      period_select = period_select
    )
  )

  # Create Gauge Measure Text Box Outputs ---------------------------------
   pwalk(
    expand.grid(c('account_type_a','account_type_b'), unique(stats_summary$measure), stringsAsFactors = F),
    ~ callModule(
      module = gauge_server,
      id = str_to_lower(str_c(.y, 'gauge',.x, sep = '_')),
      df = stats_summary %>% filter(measure == .y, account_type == .x),
      period_select = period_select
    )
  )


  # Create Trend Outputs ----------------------------------------------------

  callModule(
    module = trend_bar_server,
    id = 'trend_account_type_a',
    df = stats_summary,
    account_type_filter = 'account_type_a',
    measure_filter = trend_measure_select,
    measure_type = 'value',
    period_select = period_select
  )

  callModule(
    module = trend_comp_server,
    id = 'trend_comp_yoy_account_type_a',
    df = stats_summary,
    account_type_filter = 'account_type_a',
    measure_filter = trend_measure_select,
    measure_type = 'comp_prior_year',
    period_select = period_select
  )

  callModule(
    module = trend_comp_server,
    id = 'trend_comp_period_account_type_a',
    df = stats_summary,
    account_type_filter = 'account_type_a',
    measure_filter = trend_measure_select,
    measure_type = 'comp_rolling_avg',
    period_select = period_select
  )

  callModule(
    module = trend_comp_server,
    id = 'trend_comp_yoy_account_type_b',
    df = stats_summary,
    account_type_filter = 'account_type_b',
    measure_filter = trend_measure_select,
    measure_type = 'comp_prior_year',
    period_select = period_select
  )

  callModule(
    module = trend_comp_server,
    id = 'trend_comp_period_account_type_b',
    df = stats_summary,
    account_type_filter = 'account_type_b',
    measure_filter = trend_measure_select,
    measure_type = 'comp_rolling_avg',
    period_select = period_select
  )

  callModule(
    module = trend_bar_server,
    id = 'trend_account_type_b',
    df = stats_summary,
    account_type_filter = 'account_type_b',
    measure_filter = trend_measure_select,
    measure_type = 'value',
    period_select = period_select
  )

# Sign Up Platform Breakdown ----------------------------------------------
  pwalk(
    tibble(x=c('account_type_a','account_type_b')),
    ~callModule(
      bar_chart_server,
      id = str_to_lower(str_c('platform_bar',.x, sep = '_')),
      df = stats_platform %>% filter(account_type == .x) %>% select(-measure) %>% rename(measure = platform),
      period_select = period_select
    )
  )

# Top Content Breakdown ----------------------------------------------
  pwalk(
    tibble(x=c('account_type_a','account_type_b')),
    ~callModule(
      bar_chart_server,
      id = str_to_lower(str_c('activities_bar',.x, sep = '_')),
      df = top_activities %>% filter(account_type == .x) %>% select(-measure) %>% rename(measure = title),
      period_select = period_select
    )
  )

# DMA Breakdown ----------------------------------------------
  pwalk(
    expand.grid(c('account_type_a','account_type_b'), 'active_users', stringsAsFactors = F),
    ~callModule(
      map_server,
      id = str_to_lower(str_c('dma_map',.x, sep = '_')),
      df = stats_dma %>% filter(account_type == .x),
      measure_filter = .y,
      measure_type = map_geo_select,
      period_select = period_select
    )
  )

  output$geo_table_account_type_a <- renderDataTable({

    stats_dma %>%
      filter(
        account_type == 'account_type_a',
        measure == 'active_users',
        label == period_select()
      ) %>%
      select(
        Week = label,
        `DMA Name` = dma_name,
        `Measure` = measure,
        `Value` = value,
        `Prior Year` = comp_prior_year,
        `Prior 4 Week Comp` = comp_rolling_avg
      ) %>%
      DT::datatable(
        rownames = FALSE,
        options = list(
          paging = TRUE,
          pageLength = 25,
          searching = FALSE,
          columnDefs = list(list(className = 'dt-left', targets = "_all"))
        )
      ) %>%
      DT::formatPercentage(c('Prior Year',  'Prior 4 Week Comp'), 2)

  })

  output$geo_table_account_type_b <- renderDataTable({

    stats_dma %>%
      filter(
        account_type == 'account_type_b',
        measure == 'active_users',
        label == period_select()
      ) %>%
      select(
        Week = label,
        `DMA Name` = dma_name,
        `Measure` = measure,
        `Value` = value,
        `Prior Year` = comp_prior_year,
        `Prior 4 Week Comp` = comp_rolling_avg
      ) %>%
      DT::datatable(
        rownames = FALSE,
        options = list(
          paging = TRUE,
          pageLength = 25,
          searching = FALSE,
          columnDefs = list(list(className = 'dt-left', targets = "_all"))
        )
      ) %>%
      DT::formatPercentage(c('Prior Year',  'Prior 4 Week Comp'), 2)
  })


})
