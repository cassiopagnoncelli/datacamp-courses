library('shiny')
library('babynames')
library('dplyr')

ui <- fluidPage(
  titlePanel("What's in a Name?"),
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  tableOutput('table_top_10_names')
)

server <- function(input, output, session){
  top_10_names <- function() {
    babynames %>% 
      filter(sex == input$sex) %>% 
      filter(year == input$year) %>% 
      top_n(10, prop) %>%
      mutate(year = paste(year))
  }
  output$table_top_10_names = renderTable({
    top_10_names()
  })
}

shinyApp(ui = ui, server = server)