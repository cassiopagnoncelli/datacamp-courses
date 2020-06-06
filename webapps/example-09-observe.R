library('shiny')

ui <- fluidPage(
  textInput('name', 'Enter your name')
)

server <- function(input, output, session) {
  # Actions triggered by observers do not required further render***()
  observe({
    showNotification(paste('You have entered the name', input$name))
  })
}

shinyApp(ui = ui, server = server)
