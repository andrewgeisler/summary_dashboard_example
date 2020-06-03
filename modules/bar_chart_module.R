bar_chart_ui <- function(id) {
  ns = NS(id)
  plotlyOutput(ns('bar_chart'))
}

bar_chart_server <- function(input, output, session, df, account_filter, period_select) {
  
  p <- reactive({
    plot <- df %>% 
      filter(label == period_select()) %>%
      select(x = measure, y = value) %>%
      mutate(
        x = str_replace_all(x,'_',' '),
        x = str_to_title(x)
      ) %>%
    ggplot(
      aes(x=reorder(x, y), y=y, fill = x, label = x)) +
      geom_col() +
      geom_text(aes(y=5000),size = 3, alpha = .5) +
      scale_y_continuous(position = "right", labels = scales::comma) +
      coord_flip() +
      theme(
        axis.title = element_blank(), 
        text= element_text(size = 6), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank()
      )
    plot <- ggplotly(plot,tooltip=c("x", "y")) %>% style(textposition = "right") 
  })
  output$bar_chart <- renderPlotly(p())
}
