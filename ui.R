header <- dashboardHeader(
  title = 'Summary Dashboard',
  titleWidth = 275
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Summary Stats", tabName = "summary_stats", icon = icon("dashboard")),
    menuItem("Signup Platform", icon = icon("tablet"), tabName = "platform"),
    menuItem("Top Content", icon = icon("video"), tabName = "content"),
    menuItem("DMA Map", icon = icon("map-marked-alt"), tabName = "map"),
    menuItem("Trend", icon = icon("chart-line"), tabName = "trends"),
    period_select_wid,
    tags$div(style = 'padding-left:10px;', 'All Data Randomly Generated')
  )
)


body <- dashboardBody(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "gn-theme.css")
  ),
  
  tabItems(
    
    tabItem(
      tabName = "summary_stats",
      tabsetPanel(
        tabPanel('Account Type A', source('ui/account_type_a_summary_stats.R', local=TRUE)$value),
        tabPanel('Account Type B', source('ui/account_type_b_summary_stats.R', local=TRUE)$value)
      )
    ),

    tabItem(
      tabName = "trends",
      fluidRow(
        style = 'margin-left:6px;',
        column(3,trend_meaure_select)
      ),
      source('ui/trend.R', local=TRUE)$value
    ),
    
    tabItem(
      tabName = "platform",
      source('ui/platform.R', local=TRUE)$value
    ),
    
    tabItem(
      tabName = "content",
      source('ui/content.R', local=TRUE)$value
    ),
    
    tabItem(
      tabName = "map",
      fluidRow(
        style = 'margin-left:6px;',
        geo_meaure_select
      ),
      tabsetPanel(
        tabPanel('Account Type A', source('ui/account_type_a_geo.R', local=TRUE)$value),
        tabPanel('Account Type B', source('ui/account_type_b_geo.R', local=TRUE)$value)
      )
    ) 
    
  )
)


dashboardPage(header,sidebar,body)