library('shiny')
library('shinydashboard')

server <- function(input, output) {
  output$task_menu <- renderMenu({
    tasks <- apply(task_data, 1, function(row) {
      taskItem(text = row[["text"]],
               value = row[["value"]])
    })
    
    dropdownMenu(type = "tasks", .list = tasks)
  })
}

ui = dashboardPage(
  header = dashboardHeader(dropdownMenuOutput("task_menu")),
  sidebar = dashboardSidebar(),
  body = dashboardBody()
)

shinyApp(ui, server)
