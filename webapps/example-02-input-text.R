library('shiny')

ui = fluidPage(
  h1("Question"),
  textInput("name", "Input name"),
  textOutput("q")
)

server = function(input, output) {
  output$q = renderText({
    paste('Do you prefer dogs or cats, ', input$name, '?', sep='')
  })
}

shinyApp(ui, server)