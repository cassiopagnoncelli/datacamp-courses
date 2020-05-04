library('shiny')
library('ggplot2')

server <- function(input, output) {
  output$shapes <- renderPlot({
    usa_ufo_sightings %>%
      filter(state == input$state,
             date_sighted >= input$dates[1],
             date_sighted <= input$dates[2]) %>%
      ggplot(aes(shape)) +
      geom_bar() +
      labs(x = "Shape", y = "# Sighted")
  })
  
  output$duration_table <- renderTable({
    usa_ufo_sightings %>%
      filter(
        state == input$state,
        date_sighted >= input$dates[1],
        date_sighted <= input$dates[2]
      ) %>%
      group_by(shape) %>%
      summarize(
        nb_sighted = n(),
        avg_duration = mean(duration_sec),
        median_duration = median(duration_sec),
        min_duration = min(duration_sec),
        max_duration = max(duration_sec)
      )
  })
}

ui <- fluidPage(
  titlePanel("UFO Sightings"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "state", 
        "Choose a U.S. state:",
        choices = unique(usa_ufo_sightings$state)
      ),
      dateRangeInput(
        "dates",
        "Choose a date range:",
        start = "1920-01-01",
        end = "1950-01-01")
    ),
    mainPanel(
      plotOutput("shapes"),
      tableOutput("duration_table")
    )
  )
)

shinyApp(ui, server)