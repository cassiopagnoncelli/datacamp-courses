library('shiny')
library('babynames')
library('plotly')
library('shinythemes')

get_top_names = function(y, s)
  babynames %>%
  filter(year == y, sex == s) %>%
  arrange(desc(prop)) %>%
  head(10)

ui <- fluidPage(
  titlePanel('Top Names'),
  sidebarLayout(
    sidebarPanel(
      selectInput('sex', 'Select sex', c('M', 'F')),
      sliderInput('year', 'Select year', min = 1880, max = 2017, step = 1, value = 1880)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          'Plot',
          plotOutput('plot')
        ),
        tabPanel(
          'Table',
          tableOutput('tbl')
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # Lazy evaluation + caching.
  rval = reactive({ get_top_names(input$year, input$sex) })
  
  output$plot = renderPlot({
    ggplot(rval(), aes(x = name, y = prop)) +
      geom_col()
  })
  
  output$tbl = renderTable({ rval() })
}

shinyApp(ui, server)