fluidPage(
  tags$div(class = 'head', 'Active Users By DMA (US Only)'),
  tags$br(),
  fluidRow(
    map_ui('dma_map_family')
  ),
  fluidRow(
    style = 'padding-top:10px;',
    dataTableOutput('geo_table_family')
  )
)

