library('shiny')

ui = fluidPage(
  h1('K-means clustering'),
  selectInput('x', 'Select x', names(iris), 'Sepal.Length'),
  selectInput('y', 'Select y', names(iris), 'Sepal.Width'),
  numericInput('nb_clusters', 'Select number of clusters', 3),
  plotly::plotlyOutput('kmeans_plot')
)

server = function(input, output, session) {
  output$kmeans_plot = plotly::renderPlotly({})
}

shinyApp(ui = ui, server = server)