trend_ui <- function(id) {
  ns = NS(id)
  plotlyOutput(ns('trend_chart'))
}


trend_comp_server <- function(
  input, 
  output, 
  session, 
  df, 
  account_type_filter,
  measure_filter, 
  measure_type, 
  period_select
) {
  
  p <- reactive({
    
    chart_title <- str_c(measure_filter(),": ", measure_type)
    chart_title <- chart_title %>%
      str_replace_all('_', ' ') %>%
      str_to_title()
    
    pal <- c(
      "Above" = '#4E1FE0',
      "Below" = '#FC125F'
    )
    
    d <- df %>%
      filter(
        measure == measure_filter(),
        account_type == account_type_filter,
        start_date <= as.Date(period_select()),
        start_date >= as.Date(period_select()) - weeks(26)
      ) %>%
      mutate(
        period = as.Date(start_date),
        color = case_when(
          !!sym(measure_type) < 0 ~ 'Below',
          TRUE~'Above'
        )
      ) %>%
      select(period, account_type, measure, !!sym(measure_type), color)
  
    if(nrow(d) > 0) {
      
      p <- d %>% 
        ggplot(
        aes(
          x = period,
          y = !!sym(measure_type),
          color = color, 
          fill = color
        )
      ) +
        geom_segment(aes(xend=period, y=0, yend=!!sym(measure_type)), alpha = .6) +
        geom_point(size = 2, alpha = .9) +
        theme(
          text= element_text(size = 9), 
          axis.title = element_blank()
        ) +
        scale_color_manual(values = pal, limits = names(pal)) +
        scale_fill_manual(values = pal, limits = names(pal)) +
        scale_y_continuous(labels = scales::percent) + 
        scale_x_date(date_labels = '%m-%d', date_breaks = '14 day') +
        labs(title = chart_title) 
       
      ggplotly(p, height = 400)
    }
  })
  
  output$trend_chart <- renderPlotly(p())
  
  
}


trend_bar_server <- function(
  input, 
  output, 
  session, 
  df, 
  account_type_filter,
  measure_filter, 
  measure_type, 
  period_select
  ) {
  
  p <- reactive({
    
    chart_title <- str_c(measure_filter())#,": ", measure_type)
    chart_title <- chart_title %>%
      str_replace_all('_', ' ') %>%
      str_to_title()
    
    d <- df %>%
      filter(
        measure == measure_filter(),
        account_type == account_type_filter,
        start_date <= as.Date(period_select()),
        start_date >= as.Date(period_select())-weeks(26)
      ) %>%
      mutate(period = as.Date(start_date)) %>%
      select(period, account_type, measure, !!sym(measure_type))
    
    if(nrow(d) > 0) {
      p <- d %>%
        ggplot(aes(x = period, y = !!sym(measure_type) )) +
        geom_col(alpha=.9, fill = '#4E1FE0', color = NA) +
        theme(
          text= element_text(size = 9), 
          axis.title = element_blank()
        ) +
        labs(title = chart_title) +
        scale_x_date(date_labels = '%m-%d', date_breaks = '14 day') +
        scale_y_continuous(labels = scales::comma)
      
      ggplotly(p, height = 400)
    }
  })
  
  output$trend_chart <- renderPlotly(p())
  
  
}




