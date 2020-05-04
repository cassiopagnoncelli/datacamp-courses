library('shiny')
library('babynames')
library('plotly')
library('shinythemes')

top_trendy_names = babynames %>% filter(prop > 0.01)

ui <- fluidPage(
  titlePanel('Baby names explorer'),
  sidebarLayout(
    sidebarPanel(
      selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          'Plot',
          plotly::plotlyOutput('plot_trendy_names')
        ),
        tabPanel(
          'Table',
          DT::DTOutput('table_trendy_names')
        )
      )
    )
  )
)

server = function(input, output, session) {
  plot_trends = function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  
  output$plot_trendy_names = plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names = DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}

shinyApp(ui, server)