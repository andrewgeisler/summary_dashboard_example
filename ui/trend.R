fluidPage(
  
  tags$div(class = 'head', 'Teacher Performance Over the Prior 26 Weeks'),
  tags$br(),
  fluidRow(
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_teacher')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_period_teacher')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_yoy_teacher'))
  ),
  tags$br(),
  tags$div(class = 'head', 'Family Performance Over the Prior 26 Weeks'),
  tags$br(),
  fluidRow(
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_family')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_period_family')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_yoy_family'))
  )
)


