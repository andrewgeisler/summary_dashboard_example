map_ui <- function(id) {
  ns = NS(id)
  leafletOutput(ns('dma_map'), height = 550)
}

map_server <- function(input, output, session, df, measure_filter, measure_type, period_select) {
  
  map <- reactive({
    
    shapes_dma_map <- shapes_dma
    
    df <- df %>%
      filter(
        measure == measure_filter,
        label == period_select()
      ) %>%
      select(dma_code, dma_name, measure, !!sym(measure_type())) %>%
      mutate(
        dma_code = factor(dma_code),
        label_num = case_when(measure_type() == 'value' ~ scales::comma(!!sym(measure_type())),TRUE~scales::percent(!!sym(measure_type()))),
        label_value = str_c(dma_name, "<br/> Active Users: ", label_num)
      )
    
    shapes_dma_map@data <- shapes_dma_map@data %>%
      left_join(df, by = c("id" = "dma_code"))
    
    labs <- shapes_dma_map@data %>% pull(label_value)
    
    colors <- shapes_dma_map@data %>% pull(!!sym(measure_type()))
    
    fill_colors <- colorNumeric(palette = "Purples", domain = colors)
    
    p <- leaflet(shapes_dma_map) %>%
      addTiles() %>%
      setView(lng = -94.583, lat = 35.833, zoom = 4) %>%
      addPolygons(
        stroke = T,
        weight = .5,
        color = "#4E1FE0", smoothFactor = 0.3, fillOpacity = .85,
        fillColor = ~ fill_colors(colors),
        highlight = highlightOptions(
          weight = 2,
          color = "#4E1FE0",
          fillOpacity = 1,
          bringToFront = TRUE
        ),
        label = lapply(labs, HTML)
      ) %>%
      addLegend(
        title = "Active Users",
        pal = fill_colors,
        values = colors,
        opacity = .5,
        position = "bottomright"
      )
  })
  
  output$dma_map <- renderLeaflet(map())
}