library('shiny')

# In this example we use isolate() to stop output from
# updating when name changes.

ui = fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height (in m)', 1.5, 1, 2, step = 0.1),
      numericInput('weight', 'Enter your weight (in Kg)', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

server = function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Hi ", isolate({ input$name }), ". Your BMI is ", round(bmi, 1), sep='')
  })
}

shinyApp(ui, server)
