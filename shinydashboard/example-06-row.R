library("shiny")

body <- dashboardBody(
  fluidRow(
    # Row 1
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars"
    )
  ),
  fluidRow(
    # Row 2
    box(
      width = 12,
      title = "Regular Box, Row 2",
      "Nothing but Star Wars"
    )
  )
)


ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)