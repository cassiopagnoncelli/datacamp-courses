library('shiny')

ui = fluidPage(
  
)

server = function(input, output) {
  output$age = renderTable({
    validate(
      need(input$age != '', 'Please enter age')
    )
    
    mental_health_survey %>% summarize(
      avg_age = mean(Age)
    )
  })
}

shinyApp(ui = ui, server = server)