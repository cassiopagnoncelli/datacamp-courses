library('shiny')
library('babynames')
library('dplyr')

ui = fluidPage(
  DT::DTOutput("babynames_table")
)

server = function(input, output) {
  output$babynames_table = DT::renderDT({
    babynames %>% dplyr::sample_frac(.1)
  })
}

shinyApp(ui, server)