gauge_ui <- function(id) {
  ns = NS(id)
  flexdashboard::gaugeOutput(ns('gauge'))
}

gauge_server <- function(input, output, session, df, period_select) {
  
  value <- reactive({
    df %>%
      filter(label == period_select()) %>%
      mutate(value = round(value*100, 2)) %>%
      pull(value)
  })
  
  g <- reactive({flexdashboard::gauge(
    value(),
    min = 0, 
    max = 100, 
    symbol = '%', 
    gaugeSectors(success = c(80, 100), warning = c(40, 79), danger = c(0, 39))
  )})
  
  output$gauge <- flexdashboard::renderGauge(g())
}