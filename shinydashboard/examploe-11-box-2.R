library("shiny")
max_vel <- max(nasa_fireball$vel, na.rm = T)

body <- dashboardBody(
  fluidRow(
    # Add a value box for maximum velocity
    valueBox(max_vel,
             subtitle = "Maximum pre-impact velocity",
             icon = icon('fire')
    )
  )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)