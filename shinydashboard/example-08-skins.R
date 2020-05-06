library("shiny")

body <- dashboardBody(
  tags$head(
    tags$link(
      rel = 'stylesheet',
      type = 'text/css',
      href = 'example-08-skins.css'
    ),
    tags$style(HTML('
/// CSS HERE
    '))
  ),
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars, nothing but Star Wars"
    )
  ),
  fluidRow(
    column(width=6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 1",
             subtitle = "Gimme those Star Wars"
           )
    ),
    column(width=6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 2",
             subtitle = "Don't let them end"
           )
    )
  )
)

ui <- dashboardPage(
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body,
  skin = 'purple' # blue, black, purple, green, yellow, red
)

shinyApp(ui, server)
