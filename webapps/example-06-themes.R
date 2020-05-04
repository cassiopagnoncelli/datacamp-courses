library('shiny')
library('babynames')
library('plotly')
library('shinythemes')

top_trendy_names = babynames %>% filter(prop > 0.01)

ui = fluidPage(
  # shinythemes::themeSelector(),
  shinythemes::shinytheme('superhero'),
  selectInput('name', 'Select Name', top_trendy_names$name %>% unique()),
  plotly::plotlyOutput('plotly_trendy_names')
)

server = function(input, output, session) {
  plot_trends = function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }

  output$plotly_trendy_names =
    plotly::renderPlotly({
      plot_trends()
    })
}

shinyApp(ui = ui, server = server)