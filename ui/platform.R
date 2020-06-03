fluidPage(
  fluidRow(
    tags$div(class = 'head', 'Active Users By Sign Up Platform'),
    tags$br(),
    box(width = 6, height = 450, bar_chart_ui("platform_bar_teacher"), span(class='head','Teachers')),
    box(width = 6, height = 450, bar_chart_ui("platform_bar_family"), span(class='head','Family'))
  )
)

