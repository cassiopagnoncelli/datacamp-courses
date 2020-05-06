library("shiny")

server = function(input, output) {
  output$click_box <- renderValueBox({
    valueBox(input$click, "Click Box")
  })
}

ui = dashboardPage(
  header = dashboardHeader(),
  sidebar = dashboardSidebar(
    actionButton("click", "Update click box")
  ),
  body = dashboardBody(
    valueBoxOutput("click_box")
  )
)

shinyApp(ui, server)