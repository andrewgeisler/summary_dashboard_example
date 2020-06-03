text_box_ui <- function(id) {
  ns = NS(id)
  textOutput(ns('text_output'))
}

text_box_server <- function(input, output, session, df, period_select) {
  
  value <- reactive({

    if(unique(df$measure) == 'freq_user_percent') {
      value <- df %>% 
        filter(label == period_select()) %>%
        pull(value)
      
      if(length(value) == 0) {value <- 0}
  
      value <- scales::percent(value)
  
      return(value)
    } else {
      value <- df %>% 
        filter(label == period_select()) %>%
        pull(value)
      
      if(length(value) == 0) {value <- 0}
      
      value <- format(value,big.mark = ',', digits=3)

    }
    
    
  })
  output$text_output <- renderText(value())
}

text_box_server_comp_year <- function(input, output, session, df, period_select) {
  
  value <- reactive({
    
    
    value <- df %>% 
      filter(label == period_select()) %>%
      pull(comp_prior_year)
    
    if(length(value) == 0) {value <- 0}
    
    value <- scales::percent(value)
    
    return(value)
  })
  output$text_output <- renderText(value())
}


text_box_server_comp_period <- function(input, output, session, df, period_select) {
  
  value <- reactive({
    
    
    value <- df %>% 
      filter(label == period_select()) %>%
      pull(comp_rolling_avg)
    
    if(length(value) == 0) {value <- 0}
    
    value <- scales::percent(value)
    
    return(value)
  })
  output$text_output <- renderText(value())
}