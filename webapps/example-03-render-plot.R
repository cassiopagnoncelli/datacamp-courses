library('shiny')
library('babynames')
library('ggplot2')

ui = fluidPage(
  titlePanel('Baby name explorer'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter name', 'David') 
    ),
    mainPanel(
      plotOutput('trend')
    )
  )
)

server = function(input, output) {
  output$trend = renderPlot({
    data_name = subset(
      babynames, name == input$name
    )
    ggplot(data_name) +
      geom_line(
        aes(x = year, y = prop, color = sex)
      )
  })
}

shinyApp(ui, server)