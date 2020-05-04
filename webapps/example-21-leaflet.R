library('shiny')
library('leaflet')
library('tibble')

mass_shootings = read.csv('mass-shootings.csv') %>% as_tibble()
text_about = 'This study is compiled from a multitude of sources'

ui <- bootstrapPage(
  theme = shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput('map', height = '100%', width = '100%'),
  absolutePanel(top = 10, right = 10, id = 'controls',
                sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                dateRangeInput('date_range', 'Select Date', "2010-01-01", "2019-12-01")
  ),
  tags$style(type = "text/css", "
             html, body {width:100%;height:100%}     
             #controls{background-color:white;padding:20px;}
             ")
)

server <- function(input, output, session) {
  rval_mass_shootings <- reactive({
    mass_shootings %>%
      filter(
        fatalities <= input$nb_fatalities, 
        date > input$date[1],
        date < input$date[2]
      )
  })
  output$map <- leaflet::renderLeaflet({
    rval_mass_shootings() %>%
      leaflet() %>% 
      addTiles() %>%
      setView( -98.58, 39.82, zoom = 5) %>% 
      addTiles() %>% 
      addCircleMarkers(
        # CODE BELOW: Add parameters popup and radius and map them
        # to the summary and fatalities columns
        popup = ~ summary,
        radius = ~ fatalities,
        fillColor = 'red', color = 'red', weight = 1
      )
  })
}

shinyApp(ui, server)