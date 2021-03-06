library("shiny")

body <- dashboardBody(
  fluidRow(
    column(width=6,
           infoBox(
             width = NULL,
             title = "Regular Box, Column 1",
             subtitle = "Gimme those Star Wars"
           )
    ),
    column(width=6,
           infoBox(
             width = NULL,
             title = "Regular Box, Column 2",
             subtitle = "Don't let them end"
           )
    )
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)