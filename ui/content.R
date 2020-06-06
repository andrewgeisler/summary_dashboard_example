fluidPage(
  fluidRow(
    tags$div(class = 'head', 'Top Activities (Video Plays)'),
    tags$br(),
    box(width = 6, height = 450, bar_chart_ui("activities_bar_account_type_a"), span(class='head','Account Type A')),
    box(width = 6, height = 450, bar_chart_ui("activities_bar_account_type_b"), span(class='head','Account Type B'))
  )
)
