fluidPage(
  
  tags$div(class = 'head', 'Account Type A Performance Over the Prior 26 Weeks'),
  tags$br(),
  fluidRow(
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_account_type_a')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_period_account_type_a')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_yoy_account_type_a'))
  ),
  tags$br(),
  tags$div(class = 'head', 'Account Type B Performance Over the Prior 26 Weeks'),
  tags$br(),
  fluidRow(
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_account_type_b')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_period_account_type_b')),
    box(class='trend-chart', width=4, height = 425, trend_ui('trend_comp_yoy_account_type_b'))
  )
)


