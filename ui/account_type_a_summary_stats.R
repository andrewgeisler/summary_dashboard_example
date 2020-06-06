fluidPage(
  
  fluidRow(
    tags$div(class = 'head', textOutput('period_selected')),
    
    column(
      width = 2,
      box(class='majorBox', width = 12, text_box_ui('new_users_box_account_type_a'), span(class='caption','New Users')),
      box(class='comparisonBox', width = 6, text_box_ui('new_users_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('new_users_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 2,
      box(class='majorBox', width = 12, text_box_ui('active_users_box_account_type_a'), span(class='caption','Active Users')),
      box(class='comparisonBox', width = 6, text_box_ui('active_users_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('active_users_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 3,
      box(class='majorBox', width = 12, text_box_ui('video_plays_box_account_type_a'), span(class='caption','Total Video Plays')),
      box(class='comparisonBox', width = 6, text_box_ui('video_plays_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('video_plays_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 3,
      box(class='majorBox', width = 12, text_box_ui('total_minutes_box_account_type_a'), span(class='caption','Total Minutes')),
      box(class='comparisonBox', width = 6, text_box_ui('total_minutes_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('total_minutes_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 2,
      box(class='majorBox', width = 12, text_box_ui('freq_user_percent_box_account_type_a'), span(class='caption','Frequent User %')),
      box(class='comparisonBox', width = 6, text_box_ui('freq_user_percent_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('freq_user_percent_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    )
  ),
  
  fluidRow(
    tags$div(class = 'head', 'Performance Rates'),
    
    column(
      width = 3,
      box(class = 'gauge-row', width=12, span(class='captionSmall','Activation Rate'), gauge_ui("activation_rate_gauge_account_type_a")),
      box(class='comparisonBox', width = 6, text_box_ui('activation_rate_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('activation_rate_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    
    column(
      width = 3,
      box(class = 'gauge-row', width=12, span(class='captionSmall','Retention Rate'), gauge_ui("retention_rate_gauge_account_type_a")),
      box(class='comparisonBox', width = 6, text_box_ui('retention_rate_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('retention_rate_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 3,
      box(class = 'gauge-row', width=12, span(class='captionSmall','Churn Rate'), gauge_ui("churn_rate_gauge_account_type_a")),
      box(class='comparisonBox', width = 6, text_box_ui('churn_rate_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('churn_rate_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 3,
      box(class = 'gauge-row', width=12, span(class='captionSmall','Account A Utilization'), gauge_ui("utilization_rate_users_gauge_account_type_a")),
      box(class='comparisonBox', width = 6, text_box_ui('utilization_rate_users_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('utilization_rate_users_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    )
    
  ),
  
  
  fluidRow(
    tags$div(class = 'head', 'Average Active Day Behavior'),
    
    
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_active_days_box_account_type_a"), span(class='caption','Active Days')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_active_days_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_active_days_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_video_plays_per_active_day_box_account_type_a"), span(class='caption','Avg Video Plays')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_video_plays_per_active_day_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_video_plays_per_active_day_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_minutes_per_active_day_box_account_type_a"), span(class='caption','Avg Minutes')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_minutes_per_active_day_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_minutes_per_active_day_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_activities_per_active_day_box_account_type_a"), span(class='caption','Avg Unique Activities')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_activities_per_active_day_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_activities_per_active_day_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_daily_completion_rate_box_account_type_a"), span(class='caption','Avg Completion Rate')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_daily_completion_rate_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_daily_completion_rate_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    ),
    
    column(
      width = 2,
      box(class='minorBox', width=12, text_box_ui("avg_percent_completion_box_account_type_a"), span(class='caption','Avg Percent Complete')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_percent_completion_box_pp_account_type_a'), span(class='caption-comp','Prior 4wk Avg')),
      box(class='comparisonBox', width = 6, text_box_ui('avg_percent_completion_box_py_account_type_a'), span(class='caption-comp','Prior Year'))
    )
  )
)
