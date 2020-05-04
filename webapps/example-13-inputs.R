library('shiny')

ui = fluidPage(
  titlePanel('Inputs'),
  
  h3("Text inputs"),
  textInput('name', 'Enter a name', 'Default name'),
  selectInput('animal', 'Dogs or cats?', choices = c('dogs', 'cats')),
  textOutput('greeting'),
  textOutput('answer'),
  
  h3("Numbers"),
  numericInput('num1', "Numeric input", 3),
  sliderInput('num2', "Slider input", min = 1, max = 10, value = c(7, 8), step = 0.1),
  
  h3("Booleans"),
  checkboxInput('paris', 'Have you ever gone to Paris?', value = FALSE),
  radioButtons("dist", "Distribution type", c(
    "Normal" = 'norm',
    "Uniform" = 'unif',
    "Log-normal" = 'lnorm',
    "Exponential" = 'exp'
  )),
  
  h3("Dates"),
  dateInput("birth_date", "Birth date", value = "1988-02-11"),
  dateRangeInput("school_time", 'Time window in college', 
                 start = "2007-01-01", end = "2013-12-31")
  
  # Outputs:
  # tableOutput, dataTableOutput, imageOutput, plotOutput
  # Packages: htmlwidgets, dt, leaflet, plotly
)

server = function(input, output) {
  output$greeting = renderText({
    paste('Do you prefer dogs or cats', input$name, '?')
  })
  output$answer = renderText({
    paste('I prefer', input$animal, '!')
  })
  # Use other render functions like renderTable, renderImage, renderPlot, ...
}

shinyApp(ui, server)