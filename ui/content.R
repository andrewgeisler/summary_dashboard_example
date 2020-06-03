fluidPage(
  fluidRow(
    tags$div(class = 'head', 'Top Activities (Video Plays)'),
    tags$br(),
    box(width = 6, height = 450, bar_chart_ui("activities_bar_teacher"), span(class='head','Teachers')),
    box(width = 6, height = 450, bar_chart_ui("activities_bar_family"), span(class='head','Family'))
  )
)
